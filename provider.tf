terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
  }
}
provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "rosius"

}