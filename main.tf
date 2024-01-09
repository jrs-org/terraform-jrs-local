module "repos" {
  source       = "./modules/repos"
  repositories = var.repositories
}


module "vpc" {
  source = "./modules/vpc"
  region = var.region
  #   tags   = module.common_tags.tags
}
