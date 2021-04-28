provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfstate-labs"
    key = "keyfiles"
    region = "ap-southeast-1"
    dynamodb_table = "tfstate-labs"
  }
}
