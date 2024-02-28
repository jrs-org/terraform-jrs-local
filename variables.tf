variable "repositories" {
  type = list(object({
    name            = string
    type            = string
    path            = string
    branch_pipeline = string
    default_branch  = string
    active          = bool
  }))
  default = []
  # validation {
  #   condition     = length([for repo in var.repositories : can(regex("^jrs-(store|central)-.*$", repo.name)) || repo.name == "terraform-jrs-local" if !can(regex("^jrs-(store|central)-.*$", repo.name)) && repo.name != "terraform-jrs-local"]) == 0
  #   error_message = "Each repository name, except 'terraform-jrs-local', must start with 'jrs-' followed by either 'store' or 'central', then '-', and then any characters.\n"
  # }
}

variable "pipelines_repo" {
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

variable "scopes_branch" {
  type = list(object({
    repository_ref = string
  }))
  default = []
}


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


variable "compose_repository" {
  type = list(object({
    name                = string
    type                = string
    path                = string
    branch_pipeline     = string
    default_branch      = string
    pr_content_template = string
  }))
  default = []
  validation {
    condition     = alltrue([for repo in var.compose_repository : can(regex("^vioc-(compose)$", repo.name))])
    error_message = "Each repository name must start with 'vioc-' followed by 'compose'.\n"
  }
}
