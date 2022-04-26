terraform {
  required_version = "~> 1.1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }

  backend "s3" {
    bucket         = "jjb-tf"
    dynamodb_table = "jjb-tf-lock"
    key            = "kiwi-gha/test.tfstate"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region  = "eu-central-1"
}
