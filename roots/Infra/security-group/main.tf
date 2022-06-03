 locals {
  base_name = join("-", ["jacob", var.environment, var.region])
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region = "us-east-1"
    bucket = "jacob-sandbox-tf-state"
    key    = "sg/jacob-sandbox-tf-state"
    profile = "jacob-sandbox"
  }
}

provider "aws" {
  region     = var.region
  access_key = ""
  secret_key = ""


  assume_role {
    role_arn     = var.role_arn
    session_name = "terraform"
  }
}

data "aws_vpc" "this" {
  tags = {
    Name = join("-", [local.base_name, "vpc"])
  }
}

 resource "aws_security_group" "s3_endpoint" {
  name        = join("-", [local.base_name, "sg", "vpe", "s3"])
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description      = "Allow HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("-", [local.base_name, "sg", "vpe", "s3"])
  }
}