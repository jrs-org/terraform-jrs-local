variable "repositories" {
  type = list(object({
    name            = string
    type            = string
    path            = string
    branch_pipeline = string
    default_branch  = string
  }))
  default = []
  # validation {
  #   condition     = length([for repo in var.repositories : can(regex("^jrs-(store|central)-.*$", repo.name)) || repo.name == "terraform-jrs-local" if !can(regex("^jrs-(store|central)-.*$", repo.name)) && repo.name != "terraform-jrs-local"]) == 0
  #   error_message = "Each repository name, except 'terraform-jrs-local', must start with 'jrs-' followed by either 'store' or 'central', then '-', and then any characters.\n"
  # }
}

variable "token" {
  description = "GitHub token for authentication"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

output "repo_full_name" {
  value = module.repos.repo_full_name
}


# variable "type_org" {
#   description = "vioc"
#   type        = string
#   default = "vioc"
# }

# variable "type_store" {
#   description = "store"
#   type        = string
#   default = "store"
# }

# variable "type_central" {
#   description = "central"
#   type        = string
#   default = "central"
# }



# data "aws_caller_identity" "current" {}

# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

# output "caller_arn" {
#   value = data.aws_caller_identity.current.arn
# }

# output "caller_user" {
#   value = data.aws_caller_identity.current.user_id
# }

# data "aws_region" "current" {}
