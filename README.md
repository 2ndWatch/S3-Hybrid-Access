# Purpose
Welcome!This repository contains example code on how to create the solution architecture found in this internal 2nd Watch confluence page ->[https://2ndwatch.atlassian.net/wiki/spaces/BP/pages/2394587314/s3+Hybrid+Access+Solution+Architecture]. 
This is intended to be used as example code only because most organizations will likely already have deployed some of these AWS services if not most.

# High Level Design


# Resources

## Hybrid connectivity
Interface VPC endpoints are provisioned in a shared services VPC and are accessible from on-premises networks. When interface endpoints are deployed with ENI’s (elastic network interfaces) and are assigned private IP address from the selected subnets within the VPC. To create the connectivity to the private IP addresses a Direct Connect or Site-to-Site will need to be provisioned. The Direct Connect will require a private VIF.

## DNS
A Route53 Private Hosted Zone is created with the regional domain name of the endpoint  (s3.region-name-amazonaws.com) A Route53 Inbound Resolver is needed for on-premises applications to resolve AWS Route53 DNS names. A conditional forwarder rule needs to be configured on the on-premises DNS solution so that DNS queries For AWS names are forwarded to Route53. Lastly, apex and wildcard A records are created in the private hosted zone and traffic is routed to the s3 VPC interface endpoint. 

# Documentation
Internal 2nd Watch confluence page for overview ->
AWS blog post ->[https://aws.amazon.com/blogs/networking-and-content-delivery/secure-hybrid-access-to-amazon-s3-using-aws-privatelink/]

# Prerequisites
* Terraform Version 0.12 and later installation guide ->[https://learn.hashicorp.com/tutorials/terraform/install-cli]
* AWS CLI Installation guide ->[https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html]
* A Site-to-Site VPN or Direct Connect connection is required for this architecture

# Usage
* Update the providers tf file's access key and secret access key values.
    How to create an IAM user ->https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
* Update the backend configuration in the main tf file
    back end type s3 guide ->https://www.terraform.io/docs/language/settings/backends/s3.html
* Update the provider block in the main tf file

* Update the values in the tfvars file appropriately

# Apply new code
Navigate to the file path that the code repository was pulled to in command prompt or terminal (Mac)
Run `terraform init`this will initialize terraform for the given enviromnet
Run `terraform plan --lock=false --var-file=environments/{enviroment}-{region}.tfvars` to validate code changes are expected.
Run `terraform apply --lock=false --var-file=environments/{enviroment}-{region}.tfvars` to execute new code in the enviroment
