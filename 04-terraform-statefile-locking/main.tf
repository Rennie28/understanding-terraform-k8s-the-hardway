resource "aws_s3_bucket" "mukete" {
  count = length(var.afriyie_bucket)

  bucket = var.afriyie_bucket[count.index]

  lifecycle {
    prevent_destroy = true
  }
}

# }
# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.mukete.id
#   acl    = "private"
# }

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID" #IMPORTANT
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S" #string
  }

  lifecycle {
    prevent_destroy = true
  }
}
