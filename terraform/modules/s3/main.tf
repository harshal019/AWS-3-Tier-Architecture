resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.env}-artifacts"

  tags = {
    Name = "${var.project}-${var.env}-artifacts"
    Env  = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}