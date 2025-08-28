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

