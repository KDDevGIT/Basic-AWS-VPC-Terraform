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

# Enable/Create NAT Gateway (Private Subnet)
variable "enable_nat_gateway" {
    description = "Create NAT Gateway(s) for private subnets"
    type = bool
    default = true
}

# Single NAT Gateway (Public Subnet)
variable "single_nat_gateway" {
    description = "Use single NAT in first public subnet"
    type = bool
    default = true
}

# Tags
variable "tags" {
    description = "Common Tags"
    type = map(string)
    default = {}
}






