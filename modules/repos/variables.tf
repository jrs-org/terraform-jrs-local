variable "repositories" {
  type = list(object({
    name            = string
    type            = string
    path            = string
    branch_pipeline = string
    default_branch  = string
  }))

  description = "List of repositories"
}

# variable "repository_name" {
#   description = "Input data from the data source"
#   type        = any
#   # You can specify a more specific type if you know the structure of the data
# }
