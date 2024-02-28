module "repos" {
  source              = "./modules/repos"
  repositories        = var.repositories
  pipelines_repo      = var.pipelines_repo
  tf_plan_template    = local.tf_plan_template
  tf_repo_branch_prot = local.tf_repo_branch_prot
  compose_repository  = var.compose_repository
}


module "vpc" {
  source = "./modules/vpc"
  region = var.region
  #   tags   = module.common_tags.tags
}
