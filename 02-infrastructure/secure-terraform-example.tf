provider "aws" {
  region = "us-west-2"
  # Use environment variables or assume role instead of hardcoded credentials
  # GOOD: No hardcoded credentials in provider block
}

# Use a backend with state locking
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "app/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
  
  # Pin terraform and provider versions
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Define reusable variables
variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "secure-app"
}

# Use modules for reusable components
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  
  name = "${var.app_name}-vpc-${var.environment}"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "prod"
  enable_dns_hostnames = true
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# Private S3 bucket with encryption
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.app_name}-data-${var.environment}"
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# GOOD: Disable public access
resource "aws_s3_bucket_public_access_block" "app_data_access" {
  bucket = aws_s3_bucket.app_data.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# GOOD: Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data_encryption" {
  bucket = aws_s3_bucket.app_data.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# GOOD: Enable versioning
resource "aws_s3_bucket_versioning" "app_data_versioning" {
  bucket = aws_s3_bucket.app_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Security group with least privilege
resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-sg-${var.environment}"
  description = "Security group for application servers"
  vpc_id      = module.vpc.vpc_id
  
  # GOOD: Restricted SSH access to VPN CIDR only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]  # VPN CIDR
    description = "SSH access from VPN only"
  }
  
  # GOOD: Application access only from load balancer security group
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    description     = "Application access from load balancer only"
  }
  
  # GOOD: Restricted outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# Load balancer security group
resource "aws_security_group" "lb_sg" {
  name        = "${var.app_name}-lb-sg-${var.environment}"
  description = "Security group for load balancer"
  vpc_id      = module.vpc.vpc_id
  
  # GOOD: HTTPS only
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# EC2 instance with proper security settings
resource "aws_instance" "app_server" {
  count = var.environment == "prod" ? 3 : 1
  
  ami           = "ami-0c55b159cbfafe1f0"  # Should use a variable with data source
  instance_type = "t3.medium"
  
  # GOOD: Use private subnet
  subnet_id = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  
  # GOOD: Use security group with least privilege
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  
  # GOOD: Use IAM instance profile with least privilege
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  
  # GOOD: Enable monitoring
  monitoring = true
  
  # GOOD: Enable encrypted root volume
  root_block_device {
    volume_size = 20
    encrypted   = true
  }
  
  # GOOD: Use metadata options to prevent SSRF
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2
    http_put_response_hop_limit = 1
  }
  
  # GOOD: User data without secrets
  user_data = <<-EOF
              #!/bin/bash
              echo "APP_ENV=${var.environment}" > /etc/environment
              # Secrets should be retrieved from a secrets manager, not hardcoded
              EOF
  
  # GOOD: Tags for resource tracking
  tags = {
    Name        = "${var.app_name}-server-${var.environment}-${count.index + 1}"
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# IAM Role with least privilege
resource "aws_iam_role" "app_role" {
  name = "${var.app_name}-role-${var.environment}"
  
  # GOOD: Trust policy allowing only EC2 service
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

# GOOD: Create specific policy with least privilege
resource "aws_iam_policy" "app_policy" {
  name        = "${var.app_name}-policy-${var.environment}"
  description = "Policy for ${var.app_name} application in ${var.environment}"
  
  # GOOD: Specific permissions with resource restrictions
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.app_data.arn,
          "${aws_s3_bucket.app_data.arn}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:log-group:/aws/ec2/${var.app_name}-${var.environment}*"
      }
    ]
  })
}

# GOOD: Attach the specific policy, not an over-permissive one
resource "aws_iam_role_policy_attachment" "app_attachment" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.app_name}-profile-${var.environment}"
  role = aws_iam_role.app_role.name
}

# GOOD: Store state of sensitive outputs in parameter store
resource "aws_ssm_parameter" "app_config" {
  name        = "/${var.app_name}/${var.environment}/config"
  description = "Configuration for ${var.app_name} application in ${var.environment}"
  type        = "SecureString"
  value       = jsonencode({
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  })
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}
