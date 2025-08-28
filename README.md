## Basic-AWS-VPC-Terraform
Custom VPC with DNS support enabled. Public and private subnets across multiple Availability Zones  Internet Gateway for public subnets  NAT Gateway(s) for private subnets (single or per-AZ option)  Route tables and associations for correct traffic flow  Clean outputs for integration with other Terraform modules.

## Features
- Custom VPC with DNS support enabled  
- Public and private subnets across multiple Availability Zones  
- Internet Gateway for public subnets  
- NAT Gateway(s) for private subnets (single or per-AZ option)  
- Route tables and associations for correct traffic flow  
- Clean outputs for integration with other Terraform modules  

## Repo Layout
Basic-AWS-VPC-Terraform/
├─ versions.tf
├─ provider.tf
├─ variables.tf
├─ main.tf
├─ outputs.tf
├─ env/
│  └─ dev.tfvars
└─ modules/
   └─ vpc/
      ├─ main.tf
      ├─ variables.tf
      └─ outputs.tf

## Deployment
# (Optional) Authenticate AWS first (env vars or profile)
export AWS_PROFILE=default
export AWS_REGION=us-east-1

terraform init
terraform validate
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars" -auto-approve
terraform output
terraform destroy -var-file="env/dev.tfvars" -auto-approve




