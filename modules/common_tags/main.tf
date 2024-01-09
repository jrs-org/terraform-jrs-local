terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

locals {
  tags = {
    application_name      = var.application_name
    terraform_provisioned = true
  }
}
