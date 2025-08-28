# Module Outputs for VPC

# VPC ID
output "vpc_id" {
    value = module.vpc.vpc_id
}

# Public Subnet IDs
output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids
}

# Private Subnet IDs
output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}

# Public Route Table ID
output "public_route_table_id" {
    value = module.vpc.public_route_table_id
}

# Private Route Table ID
output "private_route_table_id" {
    value = module.vpc.private_route_table_id
}


