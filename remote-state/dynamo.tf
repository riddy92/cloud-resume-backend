resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "rhresume_app_state"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}