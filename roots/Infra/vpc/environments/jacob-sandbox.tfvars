region = "us-east-1"

role_arn = "arn:aws:iam::743283756998:role/network"

environment = "snd"

application_name = "citi-example"

vpc_cidr = "10.1.0.0/16"

azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

database_subnets = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

intra_subnets = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]

public_subnets = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]

enable_dns_support = true

enable_dhcp_options = false

dhcp_options_domain_name = ""

enable_dns_hostnames = true

dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

enable_nat_gateway = true

single_nat_gateway = true