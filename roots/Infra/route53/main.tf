locals {
  base_name = join("-", ["jacob", var.environment, var.region])
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region = "us-east-1"
    bucket = "jacob-sandbox-tf-state"
    key    = "route53/jacob-sandbox-tf-state"
    profile = "jacob-sandbox"
  }
}

provider "aws" {
  region     = var.region
  access_key = "AKIA22DZKB7DK6C3OGRT"
  secret_key = "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"


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

data "aws_vpc_endpoint" "s3" {
  tags = {
    Name = join("-", [local.base_name, "vpce", "s3"])
  }
}

resource "aws_route53_zone" "s3" {
  name = "s3.${var.region}.amazonaws.com"
  comment = "s3 privated hosted zone"

  vpc {
    vpc_id = data.aws_vpc.this.id
  }
}

resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.s3.zone_id
  name    = ""
  type    = "A"
  
  alias {
    name                   = "${lookup(data.aws_vpc_endpoint.s3.dns_entry[0], "dns_name")}"
    zone_id                = "${lookup(data.aws_vpc_endpoint.s3.dns_entry[0], "hosted_zone_id")}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard" {
  zone_id = aws_route53_zone.s3.zone_id
  name    = "*"
  type    = "A"

  alias {
    name                   = "${lookup(data.aws_vpc_endpoint.s3.dns_entry[0], "dns_name")}"
    zone_id                = "${lookup(data.aws_vpc_endpoint.s3.dns_entry[0], "hosted_zone_id")}"
    evaluate_target_health = true
  }
}