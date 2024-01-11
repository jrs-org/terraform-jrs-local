output "vpc_id" {
  description = "ID of the Wize Promt VPC"
  value       = aws_vpc.jrs_vpc.id

  depends_on = [
    aws_subnet.jrs_public_subnet,
    aws_route_table.jrs_public_route_table,
    aws_route.jrs_public_route,
    aws_route_table_association.jrs_public_route_table_association,
    # aws_subnet.jrs_private_subnet
  ]
}

output "cidr_block" {
  value       = aws_vpc.jrs_vpc.cidr_block
  description = "Virtual Private Cloud CIDR BLOCK"
  sensitive   = true
}

# output "subnet_private_id" {
#   value       = aws_subnet.jrs_private_subnet.id
#   description = "Private subnet IDs that are defined in the VPC"
#   sensitive   = true
# }


output "subnet_public_ids" {
  value       = aws_subnet.jrs_public_subnet[*].id
  description = "Public subnet IDs that are defined in the VPC"
  sensitive   = true
}
