# Child Module

# VPC ID
output "vpc_id" {
    value = aws_vpc.this.id
}

# Public Subnet IDs
output "public_subnet_ids" {
    value = local.public_subnet_ids_ordered
}

# Private Subnet IDs
output "private_subnet_ids" {
    value = local.private_subnet_ids_ordered
}

