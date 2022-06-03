# Purpose
This repository was created by 2nd Watch to deploy VPC's, Transit Gateways, Direct Connect(s) and Security Groups as part of the Cargill Front Arena Infrastructure Upgrade project.

# Prerequisites
* Terraform Version 0.12 and later
    installation guide ->https://learn.hashicorp.com/tutorials/terraform/install-cli
* AWS CLI
    Installation guide ->https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
* Ensure AWS organizations and AWS Resource Access Manager (RAM) are properly setup. Ensure "Enable sharing within your AWS Organization" has to be enabled in the RAM settings.
    ## This has been properly setup by 2nd Watch. If error messages occur in the future, you will want to double check Organization and RAM settings.
* For any new environments, the VPC must be deployed first then followed by the TGW attachment and security groups.
* Access to Stretto's internal code repo

# Usage
* Update the providers tf file's access key and secret access key values.
    How to create an IAM user ->https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html
    ## 2nd Watch used access keys that were terminated at the end of the project, consider creating a new IAM user for Terraform
* Update the backend configuration in the main tf file
    back end type s3 guide ->https://www.terraform.io/docs/language/settings/backends/s3.html
* Update the provider block in the main tf file
    ## Consider using access keys for a user that can ONLY assume role in this code block
* Update the values in the tfvars file appropriately

# Apply new code
Navigate to the file path that the code repository was pulled to in command prompt or terminal (Mac)
Run `terraform init`this will initialize terraform for the given enviromnet
Run `terraform plan --lock=false --var-file=environments/{enviroment}-{region}.tfvars` to validate code changes are expected.
Run `terraform apply --lock=false --var-file=environments/{enviroment}-{region}.tfvars` to execute new code in the enviroment