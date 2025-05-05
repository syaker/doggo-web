terraform {
  backend "s3" {
    bucket  = "ih-artifacts-bucket-tf"
    key     = "tfstate/dweb-doggo.tfstate"
    region  = "eu-west-1"
    encrypt = true
    # opcional
    # dynamodb_table = "terraform_state"
  }
}
