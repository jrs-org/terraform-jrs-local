# Public Subnet
resource "aws_subnet" "jrs_public_subnet" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.jrs_vpc.cidr_block, 8, count.index + 2)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.jrs_vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name       = "jrs public subnet ${count.index + 1}"
    Priviosing = "Terraform"
  }
}

resource "aws_route_table" "jrs_public_route_table" {
  vpc_id = aws_vpc.jrs_vpc.id

  tags = {
    Name       = "jrs route table for Public Subnet"
    Priviosing = "Terraform"
  }
}

# resource "aws_route_table" "jrs_private_route_table" {
#   vpc_id = aws_vpc.jrs_vpc.id

#   tags = {
#     Name       = "jrs route table for Private Subnet"
#     Priviosing = "Terraform"
#   }
# }

resource "aws_route" "jrs_public_route" {
  route_table_id         = aws_route_table.jrs_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jrs_igw.id
}

resource "aws_route_table_association" "jrs_public_route_table_association" {
  count          = length(aws_subnet.jrs_public_subnet)
  subnet_id      = aws_subnet.jrs_public_subnet[count.index].id
  route_table_id = aws_route_table.jrs_public_route_table.id
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
