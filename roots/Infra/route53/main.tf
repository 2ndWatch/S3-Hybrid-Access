locals {
  base_name = join("-", ["example", var.environment, var.region])
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region = ""
    bucket = ""
    key    = ""
    profile = ""
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

data "aws_vpc_endpoint" "s3" {
  tags = {
    Name = join("-", [local.base_name, "vpce", "s3"])
  }
}

data "aws_security_group" "r53" {
  tags = {
    Name = join("-", [local.base_name, "sg", "r53", "inbound", "resolver"])
  }
}

data "aws_subnet" "intra_aza" {
  tags = {
    Name = join("-", [local.base_name, "vpc", "intra", "${var.region}a"])
  }
}

data "aws_subnet" "intra_azb" {
  tags = {
    Name = join("-", [local.base_name, "vpc", "intra", "${var.region}b"])
  }
}

data "aws_subnet" "intra_azc" {
  tags = {
    Name = join("-", [local.base_name, "vpc", "intra", "${var.region}c"])
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

resource "aws_route53_resolver_endpoint" "this" {
  name      = join("-", [local.base_name, "r53", "inbound", "resolver"])
  direction = "INBOUND"

  security_group_ids = [
    data.aws_security_group.r53.id
  ]

  ip_address {
    subnet_id = data.aws_subnet.intra_aza.id
    ip        = ""
  }

  ip_address {
    subnet_id = data.aws_subnet.intra_azb.id
    ip        = ""
  }

  ip_address {
    subnet_id = data.aws_subnet.intra_azc.id
    ip        = ""
  }
}