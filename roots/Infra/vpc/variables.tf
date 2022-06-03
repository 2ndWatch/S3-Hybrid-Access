variable "region" {}

variable "role_arn" {}

variable "environment" {}

variable "application_name" {}

variable "vpc_cidr" {}

variable "azs" {
  default = []
}

variable "private_subnets" {
  default = []
}

variable "public_subnets" {
  default = []
}

variable "database_subnets" {
  default = []
}

variable "intra_subnets" {
  default = []
}

variable "enable_nat_gateway" {
  default = false
}

variable "one_nat_gateway_per_az" {
  default = false
}

variable "single_nat_gateway" {
  default = false
}

# variable "enable_s3_endpoint" {}

variable "enable_dhcp_options" {}

variable "enable_dns_hostnames" {}

variable "enable_dns_support" {}

variable "dhcp_options_domain_name" {}

variable "dhcp_options_domain_name_servers" {
  default = []
}
