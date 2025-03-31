# Private S3 bucket with encryption
#tfsec:ignore:aws-s3-enable-bucket-logging
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
#tfsec:ignore:aws-s3-encryption-customer-key
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
