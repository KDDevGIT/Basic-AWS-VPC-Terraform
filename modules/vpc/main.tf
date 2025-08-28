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

# AWS Internet Gateway Resource
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = merge(var.tags, { Name = "${var.name}-igw" })
}

# AWS Public Subnet Resource
resource "aws_subnet" "public" {
    for_each = local.pub_map

    vpc_id = aws_vpc.this.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = true

    tags = merge(var.tags, {
        Name = "${var.name}-public-${each.key}"
        Tier = "public"
    })
}

# AWS Private Subnet Resource
resource "aws_subnet" "private" {
    for_each = local.priv_map

    vpc_id = aws_vpc.this.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = merge(var.tags, {
        Name = "${var.name}-private-${each.key}"
        Tier = "private"
    })
}


