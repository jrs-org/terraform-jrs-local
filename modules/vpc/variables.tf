data "aws_availability_zones" "available_zones" {
  state = "available"
}

variable "region" {
  description = "region name"
  type        = string
}

# variable "tags" {
#   type        = any
#   description = "Common resource tags"
# }
