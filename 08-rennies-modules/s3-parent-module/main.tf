######## PARENT MODULE FOR S3

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name # 

  tags = var.tags # 
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private" # SLA
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning
  }
}
