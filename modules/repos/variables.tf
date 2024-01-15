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

# variable "repository_name" {
#   description = "Input data from the data source"
#   type        = any
#   # You can specify a more specific type if you know the structure of the data
# }

variable "tf_plan_template" {
  description = "Input data from the data source"
  type        = any
}

variable "tf_repo_branch_prot" {
  description = "Input data from the data source"
  type        = any
}
