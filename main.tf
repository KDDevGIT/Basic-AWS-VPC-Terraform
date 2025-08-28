# Main Module for VPC
module "vpc" {
  source = "./modules/vpc"

  name = var.name
  cidr_block = var.cidr_block
  azs = var.azs
  public_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  tags = var.tags
}