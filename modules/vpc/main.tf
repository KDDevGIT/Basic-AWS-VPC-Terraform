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

# AWS Route Table Resource
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

# AWS Public Default Route Resource
resource "aws_route" "public_default" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
}

# AWS Route Table Association Resource
resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public
    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

# Local Resources for Public and Private ordered subnet IDs
locals {
    public_subnet_ids_ordered = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
    private_subnet_ids_ordered = [for k in sort(keys(aws_subnet.private)) : aws_subnet.private[k].id]
}

# AWS Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(local.public_subnet_ids_ordered)) : 0
  domain = "vpc"  # Required for VPC-attached EIPs
  tags   = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })
}

# Create NAT Gateway(s) in public subnet(s) using EIPs
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(local.public_subnet_ids_ordered)) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = local.public_subnet_ids_ordered[var.single_nat_gateway ? 0 : count.index]
  tags = merge(var.tags, { Name = "${var.name}-nat-${count.index}" })
  depends_on = [aws_internet_gateway.this]
}

# Single NAT Mode 
# Creates exactly 1 private Route Table when NAT enabled AND Using single NAT
resource "aws_route_table" "private_single" {
    count = var.enable_nat_gateway && var.single_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.this.id
    tags = merge(var.tags, { Name = "${var.name}-private-rt" })
}

# Add Default Route to Private Route Table
resource "aws_route" "private_single_default" {
    count = length(aws_route_table.private_single)
    route_table_id = aws_route_table.private_single[0].id
    # Default Route (Outbound)
    destination_cidr_block = "0.0.0.0/0"
    # Point default route to single NAT in public subnet
    nat_gateway_id = aws_nat_gateway.this[0].id
}

# Associate every private subnet to single private route table
resource "aws_route_table_association" "private_single_assoc" {
    for_each = var.enable_nat_gateway && var.single_nat_gateway ? aws_subnet.private : {}
    subnet_id = each.value.id
    route_table_id = aws_route_table.private_single[0].id
}

# Per Avail. Zone NAT Mode
# One private Route Table per Private Subnet/Avail. Zone
resource "aws_route_table" "private_per_az" {
    for_each = var.enable_nat_gateway && !var.single_nat_gateway ? aws_subnet.private : {}
    vpc_id = aws_vpc.this.id
    tags = merge(var.tags, { Name = "${var.name}-private-rt-${each.key}" })
}

# Default route per Avail. Zone Route Tables
resource "aws_route" "private_per_az_default" {
    for_each = var.enable_nat_gateway && !var.single_nat_gateway ? aws_route_table.private_per_az : {}
    route_table_id = each.value.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[tonumber(each.key)].id
}

# Associate private subnet with its matching Per Avail. Zone Route Table
resource "aws_route_table_association" "private_per_az_assoc" {
    for_each = var.enable_nat_gateway && !var.single_nat_gateway ? aws_subnet.private : {}
    subnet_id = each.value.id
    route_table_id = aws_route_table.private_per_az[each.key].id
}







