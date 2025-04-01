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
