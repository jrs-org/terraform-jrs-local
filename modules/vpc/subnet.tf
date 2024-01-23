# Public Subnet
resource "aws_subnet" "jrs_public_subnet" {
  count                   = terraform.workspace == "dev" ? 2 : 0
  cidr_block              = cidrsubnet(aws_vpc.jrs_vpc[0].cidr_block, 8, count.index + 2)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.jrs_vpc[0].id
  map_public_ip_on_launch = true

  tags = {
    Name       = "jrs public subnet ${count.index + 1}"
    Priviosing = "Terraform"
  }
}

resource "aws_route_table" "jrs_public_route_table" {
  count  = terraform.workspace == "dev" ? 1 : 0
  vpc_id = aws_vpc.jrs_vpc[0].id

  tags = {
    Name       = "jrs route table for Public Subnet"
    Priviosing = "Terraform"
  }
}

##enter comment
# resource "aws_route_table" "jrs_private_route_table" {
#   vpc_id = aws_vpc.jrs_vpc.id

#   tags = {
#     Name       = "jrs route table for Private Subnet"
#     Priviosing = "Terraform"
#   }
# }

resource "aws_route" "jrs_public_route" {
  count                  = terraform.workspace == "dev" ? 1 : 0
  route_table_id         = aws_route_table.jrs_public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jrs_igw[0].id
}


resource "aws_route_table_association" "jrs_public_route_table_association" {
  count          = terraform.workspace == "dev" ? length(aws_subnet.jrs_public_subnet) : 0
  subnet_id      = aws_subnet.jrs_public_subnet[count.index].id
  route_table_id = aws_route_table.jrs_public_route_table[0].id
}

# resource "aws_route_table_association" "jrs_private_route_table_association" {
#   subnet_id      = aws_subnet.jrs_private_subnet.id
#   route_table_id = aws_route_table.jrs_private_route_table.id
# }

# Private Subnet
# resource "aws_subnet" "jrs_private_subnet" {
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = data.aws_availability_zones.available_zones.names[0]
#   vpc_id            = aws_vpc.jrs_vpc.id

#   tags = {
#     Name       = "jrs private subnet"
#     Priviosing = "Terraform"
#   }
# }

# resource "aws_route" "jrs_private_route" {
#   route_table_id         = aws_route_table.jrs_private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
# #   nat_gateway_id         = aws_nat_gateway.jrs_ngw.id
# }
