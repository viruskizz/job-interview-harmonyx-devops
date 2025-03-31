# Use modules for reusable components
#tfsec:ignore:aws-ec2-no-public-ip-subnet tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
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
    cidr_blocks = ["10.10.0.0/16"]
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
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
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
    cidr_blocks = ["10.10.0.0/16"]
    description = "Allow all outbound traffic"
  }
  
  # GOOD: Tags for resource tracking
  tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}