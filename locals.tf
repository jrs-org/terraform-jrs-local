locals {
  tf_plan_template = [for repo in var.repositories : repo if repo.name == "terraform-jrs-local"]
  tf_repo_branch_prot = [for repo in var.repositories : repo if repo.name != "terraform-jrs-local"]
}
