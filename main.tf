terraform {
    backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
    workspace_key_prefix = "ap-south-1/m1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}
