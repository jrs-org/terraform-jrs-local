terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

# #repositories creation DO NOT USE
# resource "github_repository" "repositories" {
#   for_each = {for repo in var.repositories: repo.name => repo}
#   # Configuration options
#   name        = each.value.name
#   description = "Repository managed by Terraform"
#   visibility  = "public"
# }


#repositories branch creation and autoinit
resource "github_repository" "repository_branch_autoinit" {
  for_each = { for repo in var.repositories : repo.name => repo if terraform.workspace == "dev" }
  name     = each.value.name
  #for_each = { for repo in var.repositories : repo.name => repo }
  # Configuration options
  #name        = each.value.name
  description            = "Repository managed by Terraform"
  visibility             = "public"
  auto_init              = true
  delete_branch_on_merge = true
}

# # Branch creation for all repos
# resource "github_branch" "branch" {
#   count = terraform.workspace != "dev" ? 0 : length(var.repositories)
#   repository = var.repositories[count.index].name
#   branch = var.repositories[count.index].default_branch
#   # dynamic "scope" {
#   #   for_each = var.scopes_branch
#   #   content {
#   #     # repository_id  = data.azuredevops_git_repository.repositories[count.index].id
#   #     branch = scope.value["repository_ref"]
#   #     match_type     = "Exact"
#   #   }
#   # }
# }


#rename current branch to master
resource "github_branch_default" "default" {
  for_each   = { for repo in var.repositories : repo.name => repo if terraform.workspace == "dev" }
  repository = each.value.name
  branch     = each.value.default_branch
  # for_each   = { for repo in var.repositories : repo.name => repo }
  # repository = each.value.name
  # branch     = each.value.default_branch
  rename     = true
  depends_on = [github_repository.repository_branch_autoinit]
}

# add pipeline template to all repos in tfvars
resource "github_repository_file" "pipeline_file" {
  for_each            = { for repo in var.repositories : repo.name => repo if terraform.workspace == "dev" }
  repository          = each.value.name
  branch              = "refs/heads/${each.value.branch_pipeline}"
  file                = ".github/workflows/github-pipelines.yml"
  content             = file("${path.cwd}/assets/github-pipelines.yml") #,{ type = var.repositories[count.index].type })
  commit_message      = "Añade o actualiza pipelines_file via terraform ***NO_CI***"
  overwrite_on_create = false
  depends_on          = [github_branch_default.default]

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}


#repositories pipeline repo branch creation and autoinit
resource "github_repository" "repository_pipelines" {
  for_each = { for repo in var.pipelines_repo : repo.name => repo if terraform.workspace == "dev" }
  name     = each.value.name
  #for_each = { for repo in var.repositories : repo.name => repo }
  # Configuration options
  #name        = each.value.name
  description = "Repository managed by Terraform"
  visibility  = "public"
  auto_init   = true

}

#rename current pipelines branch to master
resource "github_branch_default" "default_pipelines" {
  for_each   = { for repo in var.pipelines_repo : repo.name => repo if terraform.workspace == "dev" }
  repository = each.value.name
  branch     = each.value.default_branch
  # for_each   = { for repo in var.repositories : repo.name => repo }
  # repository = each.value.name
  # branch     = each.value.default_branch
  rename     = true
  depends_on = [github_repository.repository_pipelines]
}

## add ci.yml file to pipilines repo
resource "github_repository_file" "ci_file" {
  for_each            = { for repo in var.pipelines_repo : repo.name => repo if terraform.workspace == "dev" }
  repository          = each.value.name
  branch              = "refs/heads/${each.value.branch_pipeline}"
  file                = ".github/workflows/ci.yml"
  content             = file("${path.cwd}/assets/ci.yml") #,{ type = var.repositories[count.index].type })
  commit_message      = "Añade o actualiza ci.yml via terraform ***NO_CI***"
  overwrite_on_create = false
  depends_on          = [github_branch_default.default_pipelines]

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}

# add pull request template to all repos in tfvars
resource "github_repository_file" "pr_template" {
  for_each            = { for repo in var.repositories : repo.name => repo if terraform.workspace == "dev" }
  repository          = each.value.name
  branch              = "refs/heads/${each.value.branch_pipeline}"
  file                = ".github/pull_request_template.md"
  content             = file("${path.cwd}/assets/pull_request_template.md") #,{ type = var.repositories[count.index].type })
  commit_message      = "Añade o actualiza pr_template via terraform ***NO_CI***"
  overwrite_on_create = true
  depends_on          = [github_repository_file.pipeline_file]

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}


# add terraform plan template to terraform repo in tfvars
resource "github_repository_file" "tf_plan_template" {
  count               = terraform.workspace != "dev" ? 0 : (length(var.tf_plan_template) > 0 ? 1 : 0)
  repository          = var.tf_plan_template[0].name
  branch              = "refs/heads/${var.tf_plan_template[0].branch_pipeline}"
  file                = ".github/workflows/terraform_plan.yaml"
  content             = file("${path.cwd}/assets/terraform_plan.yaml")
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}

# add terraform apply template to terraform repo in tfvars
resource "github_repository_file" "tf_apply_template" {
  count               = terraform.workspace != "dev" ? 0 : (length(var.tf_plan_template) > 0 ? 1 : 0)
  repository          = var.tf_plan_template[0].name
  branch              = "refs/heads/${var.tf_plan_template[0].branch_pipeline}"
  file                = ".github/workflows/terraform_apply.yaml"
  content             = file("${path.cwd}/assets/terraform_apply.yaml")
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}


# # branch protection
# # Protect the main branch of the foo repository. Additionally, require that
# # the "ci/check" check ran by the Github Actions app is passing and only allow
# # the engineers team merge to the branch.

resource "github_branch_protection" "branch_policy" {
  for_each      = { for repo in var.repositories : repo.name => repo if terraform.workspace == "dev" }
  repository_id = each.value.name
  pattern       = each.value.default_branch
  depends_on    = [github_repository_file.pr_template]

  enforce_admins                  = false
  allows_deletions                = false
  allows_force_pushes             = true
  require_conversation_resolution = true

  # required_status_checks {
  #   strict   = true
  #   contexts = ["ci/github-pipelines.yml"]
  # }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
    pull_request_bypassers = [
      "jrs-org/jrs-test-team",
    ]
    dismissal_restrictions = [
      # data.github_user.example.node_id,
      # github_team.example.node_id,
      "jrs-org/jrs-test-team",
      # "exampleorganization/exampleteam",
    ]
  }

  push_restrictions = [
    # data.github_user.example.node_id,
    "jrs-org/jrs-test-team",
    # "exampleorganization/exampleteam",
    # you can have more than one type of restriction (teams + users). If you use
    # more than one type, you must use node_ids of each user and each team.
    # github_team.example.node_id
    # github_user.example-2.node_id
  ]

  force_push_bypassers = [
    # data.github_user.example.node_id,
    "jrs-org/jrs-test-team",
    # "exampleorganization/exampleteam",
    # you can have more than one type of restriction (teams + users)
    # github_team.example.node_id
    # github_team.example-2.node_id
  ]

  lifecycle {
    ignore_changes = [
      allows_force_pushes,
      force_push_bypassers,
      push_restrictions,
      required_pull_request_reviews,
    ]
  }
}


# #branch protection
# # Protect the main branch of the foo repository. Additionally, require that
# # the "ci/check" check ran by the Github Actions app is passing and only allow
# # the engineers team merge to the branch.

# resource "github_branch_protection" "branch_policy" {
#   for_each      = { for repo in var.repositories : repo.name => repo }
#   repository_id = each.value.name
#   pattern       = each.value.default_branch
#   depends_on    = [github_repository_file.pr_template]

#   enforce_admins   = true
#   allows_deletions = false

#   required_status_checks {
#     strict   = true
#     contexts = ["ci/github-pipelines.yml"]
#   }

#   required_pull_request_reviews {
#     dismiss_stale_reviews           = true
#     restrict_dismissals             = false
#     require_code_owner_reviews      = true
#     required_approving_review_count = 2
#     # dismissal_restrictions = [
#     #   data.github_user.example.node_id,
#     #   github_team.example.node_id,
#     #   "/exampleuser",
#     #   "exampleorganization/exampleteam",
#     # ]
#   }

#   #   push_restrictions = [
#   #     # data.github_user.example.node_id,
#   #     "/exampleuser",
#   #     # "exampleorganization/exampleteam",
#   #     # you can have more than one type of restriction (teams + users). If you use
#   #     # more than one type, you must use node_ids of each user and each team.
#   #     # github_team.example.node_id
#   #     # github_user.example-2.node_id
#   #   ]

#   #   force_push_bypassers = [
#   #     # data.github_user.example.node_id,
#   #     "/exampleuser",
#   #     # "exampleorganization/exampleteam",
#   #     # you can have more than one type of restriction (teams + users)
#   #     # github_team.example.node_id
#   #     # github_team.example-2.node_id
#   #   ]

# }


## create and apply polices to repository compose
resource "github_repository" "repository_configuration_compose" {
  for_each = { for repo in var.compose_repository : repo.name => repo if terraform.workspace == "dev" }
  ## Configuration options
  name               = each.value.name
  visibility         = "internal"
  auto_init          = true
  allow_merge_commit = false
  allow_rebase_merge = false
  allow_auto_merge   = true
  allow_squash_merge = true
  ## this combination of squash commit PR_TITLE and message BLANK is needed to force the rule to only use the PR title for the squash commit message
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge      = true
  has_wiki                    = true
  has_issues                  = true
}

## rename current branch to master
## the master branch is created by default, so only create this default branch resource if the default is not set to master
resource "github_branch_default" "default_compose" {
  for_each   = { for repo in var.compose_repository : repo.name => repo if terraform.workspace == "dev" && repo.default_branch != "master" }
  repository = each.value.name
  branch     = each.value.default_branch
  rename     = true
  depends_on = [github_repository.repository_configuration_compose]
}
