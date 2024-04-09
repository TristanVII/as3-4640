# Configure terraform settings
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

  }

  # Backend configuration which defines 
  # where state snapshots are stored.
  backend "s3" {
    bucket = "acit-assignment3-bucket1"
    key = "terraform.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "assignment3-dynamodb"
  }
}

provider "aws" {
  region = var.aws_region
}