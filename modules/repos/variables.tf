variable "repositories" {
  type = list(object({
    name            = string
    type            = string
    path            = string
    branch_pipeline = string
    default_branch  = string
  }))

  description = "List of repositories"
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

  description = "List of pipelines repo"
  # validation {
  #   condition     = length([for repo in var.repositories : can(regex("^jrs-(store|central)-.*$", repo.name)) || repo.name == "terraform-jrs-local" if !can(regex("^jrs-(store|central)-.*$", repo.name)) && repo.name != "terraform-jrs-local"]) == 0
  #   error_message = "Each repository name, except 'terraform-jrs-local', must start with 'jrs-' followed by either 'store' or 'central', then '-', and then any characters.\n"
  # }
}

variable "tf_plan_template" {
  description = "Input data from the data source"
  type        = any
}

variable "tf_repo_branch_prot" {
  description = "Input data from the data source"
  type        = any
}


variable "scopes_branch" {
  type = list(object({
    repository_ref = string
  }))
  default = []
}


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
