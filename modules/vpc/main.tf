resource "aws_vpc" "jrs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name       = "jrs VPC"
    Priviosing = "Terraform"
  }
}

resource "aws_internet_gateway" "jrs_igw" {
  vpc_id = aws_vpc.jrs_vpc.id

  tags = {
    Name       = "jrs VPC Internet Gateway"
    Priviosing = "Terraform"
  }
}
