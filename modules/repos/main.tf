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
resource "github_repository" "repository_branch_autoninit" {
  for_each = { for repo in var.repositories : repo.name => repo }
  # Configuration options
  name        = each.value.name
  description = "Repository managed by Terraform"
  visibility  = "public"
  #   default_branch = each.value.default_branch
  auto_init = true

}

#rename current branch to master
resource "github_branch_default" "default" {
  for_each   = { for repo in var.repositories : repo.name => repo }
  repository = each.value.name
  branch     = each.value.default_branch
  rename     = true
}

#branch protection
# Protect the main branch of the foo repository. Additionally, require that
# the "ci/check" check ran by the Github Actions app is passing and only allow
# the engineers team merge to the branch.

# resource "github_branch_protection" "branch_policy" {
#   for_each      = { for repo in var.repositories : repo.name => repo }
#   repository_id = each.value.name
#   pattern       = each.value.default_branch
#   # also accepts repository name
#   # repository_id  = github_repository.example.name

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
#   #     "/josue-r",
#   #     # "exampleorganization/exampleteam",
#   #     # you can have more than one type of restriction (teams + users). If you use
#   #     # more than one type, you must use node_ids of each user and each team.
#   #     # github_team.example.node_id
#   #     # github_user.example-2.node_id
#   #   ]

#   #   force_push_bypassers = [
#   #     # data.github_user.example.node_id,
#   #     "/josue-r",
#   #     # "exampleorganization/exampleteam",
#   #     # you can have more than one type of restriction (teams + users)
#   #     # github_team.example.node_id
#   #     # github_team.example-2.node_id
#   #   ]

# }


resource "github_repository_file" "pipeline_file" {
  count               = terraform.workspace != "dev" ? 0 : length(var.repositories)
  repository          = var.repositories[count.index].name
  branch              = "refs/heads/${var.repositories[count.index].branch_pipeline}"
  file                = ".github/workflows/github-pipelines.yml"
  content             = file("${path.cwd}/assets/github-pipelines.yml") #,{ type = var.repositories[count.index].type })
  commit_message      = "Añade o actualiza pipelines_file via terraform ***NO_CI***"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}


resource "github_repository_file" "pr_template" {
  count               = terraform.workspace != "dev" ? 0 : length(var.repositories)
  repository          = var.repositories[count.index].name
  branch              = "refs/heads/${var.repositories[count.index].branch_pipeline}"
  file                = ".github/pull_request_template.md"
  content             = file("${path.cwd}/assets/pull_request_template.md") #,{ type = var.repositories[count.index].type })
  commit_message      = "Añade o actualiza pr_template via terraform ***NO_CI***"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      file,
      commit_message
    ]
  }
}
