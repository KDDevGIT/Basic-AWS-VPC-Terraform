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

# CIDR Block
variable "cidr_block" {
    description = "VPC CIDR"
    type = string
    default = "10.0.0.0/16"
}

# Availability Zones
variable "azs" {
    description = "List of Availability Zones"
    type = list(string)
}

# Public Subnet CIDRs
variable "public_subnet_cidrs" {
    description = "CIDRs for public subnets (One per Avail. Zone)"
    type = list(string)
}

# Private Subnet CIDRs
variable "private_subnet_cidrs" {
    description = "CIDRs for private subnets (One per Avail. Zone)"
    type = list(string)
}

