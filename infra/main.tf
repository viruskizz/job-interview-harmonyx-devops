provider "aws" {
  region = "us-west-2"
  # SECURITY ISSUE: Hardcoded credentials
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

# SECURITY ISSUE: Public S3 bucket with no encryption
resource "aws_s3_bucket" "app_data" {
  bucket = "my-app-data-bucket"
  acl    = "public-read"
}

# SECURITY ISSUE: Security group with wide open access
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"
  
  # SECURITY ISSUE: Open to the world SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # SECURITY ISSUE: Open to the world application access
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # SECURITY ISSUE: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SECURITY ISSUE: EC2 instance with too many permissions
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  # SECURITY ISSUE: Root EBS volume without encryption
  root_block_device {
    volume_size = 20
    encrypted   = false
  }
  
  # SECURITY ISSUE: Instance connects to public subnet
  subnet_id     = aws_subnet.public_subnet.id
  
  # SECURITY ISSUE: IAM role with admin access
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  
  user_data = <<-EOF
              #!/bin/bash
              # SECURITY ISSUE: Sensitive data in user data
              echo "MYSQL_PASSWORD=SuperSecretPassword123" > /etc/environment
              echo "API_KEY=sk_live_12345abcdef" >> /etc/environment
              EOF
  
  tags = {
    Name = "AppServer"
  }
}

# SECURITY ISSUE: IAM Role with excessive permissions
resource "aws_iam_role" "app_role" {
  name = "app-role"
  
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
}

# SECURITY ISSUE: Admin policy attachment
resource "aws_iam_role_policy_attachment" "admin_attachment" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app-profile"
  role = aws_iam_role.app_role.name
}
