output "repo_full_name" {
  description = "Map of repo full names"
  value       = { for repo in github_repository.repository_branch_autoinit : repo.name => repo.full_name }
}
