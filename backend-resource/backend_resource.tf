resource "aws_s3_bucket" "tf_remote_state" {
  bucket = "lf-tf-${var.environment}"
  acl    = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "tf_statelock" {
  hash_key     = "LockID"
  name         = "lf-tf-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
