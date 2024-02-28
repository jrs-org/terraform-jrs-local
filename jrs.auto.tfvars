
repositories = [
  {
    name            = "MS-Test10"
    type            = "ms"
    path            = "ms"
    branch_pipeline = "master"
    default_branch  = "master"
    active          = true
  },
  {
    name            = "MS-Tes11"
    type            = "ms"
    path            = "ms"
    branch_pipeline = "master"
    default_branch  = "master"
    active          = true
  },

  {
    name            = "MS-Test12"
    type            = "ms"
    path            = "ms"
    branch_pipeline = "master"
    default_branch  = "master"
    active          = true
  },
  # {
  #   name            = "MS-Test13"
  #   type            = "ms"
  #   path            = "ms"
  #   branch_pipeline = "master"
  #   default_branch  = "master"
  #   active                  = true
  # },
  # {
  #   name            = "MS-Test14"
  #   type            = "ms"
  #   path            = "ms"
  #   branch_pipeline = "master"
  #   default_branch  = "master"
  # },

]

pipelines_repo = [
  {
    name            = "Pipelines"
    type            = "DevOps"
    path            = "DevOps"
    branch_pipeline = "master"
    default_branch  = "master"
  },

]
# General Value for region
region = "us-east-1"


# Branches dynamic block
scopes_branch = [
  {
    repository_ref = "refs/heads/dev"
  },
  {
    repository_ref = "refs/heads/qa"
  },
  {
    repository_ref = "refs/heads/prod"
  },
]


compose_repository = [
  {
    name                = "vioc-compose"
    type                = "DevOps"
    path                = "devops"
    branch_pipeline     = "master"
    default_branch      = "master"
    pr_content_template = "pull_request_template.md"
  },
]
