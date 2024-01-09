#!/bin/bash

# Define your repository names
REPOSITORIES=("terraform-jrs-local")

# Loop through each repository and import it
for REPO in "${REPOSITORIES[@]}"; do
  terraform import -var-file="jrs.auto.tfvars" "module.repos.github_repository.repositories[\"$REPO\"]" $REPO
done
