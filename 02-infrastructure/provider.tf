provider "aws" {
  region = "us-west-2"
  # Use environment variables or assume role instead of hardcoded credentials
  # GOOD: No hardcoded credentials in provider block
}

# Use a backend with state locking
terraform {
  backend "s3" {
    bucket         = "job-interview-terraform-state"
    key            = "app/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "job-interview-terraform-lock-table"
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