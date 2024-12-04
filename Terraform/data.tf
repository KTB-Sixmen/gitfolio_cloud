data "terraform_remote_state" "dev" {
  backend = "s3"
  config = {
    bucket   = "gitfolio-tfstate"
    key      = "terraform.tfstate.d/dev/terraform.tfstate"
    region   = "ap-northeast-2"
    encrypt  = true
    }
}

data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket   = "gitfolio-tfstate"
    key      = "terraform.tfstate.d/prod/terraform.tfstate"
    region   = "ap-northeast-2"
    encrypt  = true
    }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket   = "gitfolio-tfstate"
    key      = "terraform.tfstate.d/shared/terraform.tfstate"
    region   = "ap-northeast-2"
    encrypt  = true
    }
}
