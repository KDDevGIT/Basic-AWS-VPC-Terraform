# Child Module

# Local Private and Public subnet CIDR Mapping
locals {
    pub_map = {
        for idx, cidr in var.public_var.public_subnet_cidrs : 
        tostring(idx) => { cidr = cidr, az = var.azs[idx] }
    }
    priv_map = {
        for idx, cidr in var.var.private_subnet_cidrs :
        tostring(idx) => { cidr = cidr, az = var.azs[idx] }
    }
}

# AWS VPC Resource 
resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = merge(var.tags, { Name = "${var.name}-vpc"})
}


