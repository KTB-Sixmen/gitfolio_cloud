terraform {
  backend "s3" {
    bucket               = "gitfolio-tfstate"
    key                  = "terraform.tfstate"
    region               = "ap-northeast-2"
    dynamodb_table       = "gitfolio-tfstate-lock"
    workspace_key_prefix = "terraform.tfstate.d"
    encrypt              = true
  }
}