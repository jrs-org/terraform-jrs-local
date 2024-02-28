locals {
  tf_plan_template    = [for repo in var.repositories : repo if repo.name == "terraform-jrs-local"]
  tf_repo_branch_prot = [for repo in var.repositories : repo if repo.name != "terraform-jrs-local"]
  repo_map            = { for i, repo in var.repositories : tostring(i) => repo }
  ms_keys             = compact([for i, repo in local.repo_map : repo.type == "ms" ? repo.active ? i : "" : ""])
  ms_map              = [for key in local.ms_keys : lookup(local.repo_map, key)]
}
