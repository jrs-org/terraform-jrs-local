#Referencia a todos los repositorios dentro del proyecto jrs-local
data "github_repository" "repositories" {
  count = terraform.workspace != "dev" ? 0 : length(var.repositories)
  name  = var.repositories[count.index].name
}
