output "tags" {
  description = "Common resource tags"
  value       = { for key, value in local.tags : key => value if value != null }
}
