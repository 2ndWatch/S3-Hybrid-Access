# Purpose
Welcome! This repository contains _example_ code on how to create hybrid connectivity to Amazon s3. This architecture contains multiple technologies working together to achieve the common goal of safe connectivity to s3. For more information see the links below:

Internal 2nd Watch confluence page ->[https://2ndwatch.atlassian.net/wiki/spaces/BP/pages/2394587314/s3+Hybrid+Access+Solution+Architecture]

AWS blog post ->[https://aws.amazon.com/blogs/networking-and-content-delivery/secure-hybrid-access-to-amazon-s3-using-aws-privatelink/]



# High Level Design
![Screen Shot 2022-06-06 at 2 17 19 PM](https://user-images.githubusercontent.com/86376621/172231459-78da121d-f967-48e5-a0b1-ab53db36891e.png)

# Prerequisites
* Terraform Version 0.12 and later installation guide ->[https://learn.hashicorp.com/tutorials/terraform/install-cli]
* AWS CLI Installation guide ->[https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html]
* A Site-to-Site VPN or Direct Connect connection is required for this architecture **_Note:_ example code is not included for this**

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
