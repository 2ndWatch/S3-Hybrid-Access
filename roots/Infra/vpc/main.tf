locals {
  base_name = join("-", ["jacob", var.environment, var.region])
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region = "us-east-1"
    bucket = "jacob-sandbox-tf-state"
    key    = "vpc/jacob-sandbox-tf-state"
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

data "aws_security_group" "this" {
  name = join("-", [local.base_name, "sg", "vpe", "s3"])
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name                   = join("-", [local.base_name, "vpc"])
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  private_subnets        = var.private_subnets
  intra_subnets          = var.intra_subnets
  database_subnets       = var.database_subnets
  public_subnets         = var.public_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = var.single_nat_gateway

  enable_dhcp_options                = var.enable_dhcp_options
  dhcp_options_domain_name           = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers   = var.dhcp_options_domain_name_servers
  enable_dns_hostnames               = var.enable_dns_hostnames
  enable_dns_support                 = var.enable_dns_support 

  #these tags are applied to all resources
  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.intra_subnets

  security_group_ids = [
    data.aws_security_group.this.id,
  ]

  tags = {
    Environment = var.environment
    Name        = join("-", [local.base_name, "vpce", "s3"])
  }

  # private_dns_enabled = true
}