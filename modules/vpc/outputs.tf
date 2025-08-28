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

# Public Route Table ID
output "public_route_table_id" {
    value = aws_route_table.public.id
}

# Private Route Table ID(s)
output "private_route_table_ids" {
    value = concat(
        [for r in aws_route_table.private_single : r.id],
        [for k in sort(keys(aws_route_table.private_per_az)) : aws_route_table.private_per_az[k].id]
    )
}

# NAT Gateway IDs
output "nat_gateway_ids" {
    value = [for i in aws_nat_gateway.this : i.id]
}

