terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Simple S3 bucket for demonstration
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "cloudability-governance-demo-${formatdate("YYYYMMDD", timestamp())}"

  tags = {
    Name        = "Cloudability Demo Bucket"
    Environment = "prod"
    Project     = "governance-demo"
    ManagedBy   = "Terraform"
  }
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "demo_bucket_versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "demo_bucket_encryption" {
  bucket = aws_s3_bucket.demo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
