module "repos" {
  source           = "./modules/repos"
  repositories     = var.repositories
  tf_plan_template = local.tf_plan_template
}


module "vpc" {
  source = "./modules/vpc"
  region = var.region
  #   tags   = module.common_tags.tags
}




