module "dynamodb-account" {
  source = "./tf-module/dynamodb"
  name = "test-db"
  hash_key = "key"
  range_key = "range"
  dynamodb_read_capacity = 1
  dynamodb_write_capacity = 1
  read_target_value = 50
  write_target_value = 60
}
