locals {
  environment = {
      "d" = "dev"
      "i" = "pre"
      "p" = "pro"
  }
}

provider "aws" {
  region = "sa-east-1"
}