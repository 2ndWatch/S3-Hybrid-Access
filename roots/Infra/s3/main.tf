locals {
  base_name = join("-", ["jacob", var.environment, var.region])
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region = "us-east-1"
    bucket = "jacob-sandbox-tf-state"
    key    = "s3/jacob-sandbox-tf-state"
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

data "aws_vpc_endpoint" "s3" {
  tags = {
    Name = join("-", [local.base_name, "vpce", "s3"])
  }
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  statement {
    sid    = "DenyUnencrypted"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${join("-", [local.base_name, "s3"])}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  statement {
    sid   = "Allow From VPCE"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${join("-", [local.base_name, "s3"])}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpce"
      values   = ["${data.aws_vpc_endpoint.s3.id}"]
    }


  }
  
}

resource "aws_s3_bucket" "this" {
  bucket = join("-", [local.base_name, "s3",])


  tags = {
    Name        = join("-", [local.base_name, "s3"])
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}