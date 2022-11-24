terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region     = "ap-northeast-1"
  access_key = "AKIA4PQ5PXF3E5H5UVXQ"
  secret_key = "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"
}

