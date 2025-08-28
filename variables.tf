# Region 
variable "aws_region" {
    description = "AWS region for deployment"
    type = string
}

# Name
variable "name" {
    description = "Base name for resources"
    type = string
    default = "basic-vpc"
}