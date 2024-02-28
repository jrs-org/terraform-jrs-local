#!/usr/bin/env bash

# Example of how to rename repos that are terraform managed

set -e

# Example old and new names
oldName="MS-Test157"  # This should be the existing name in the Terraform state
newName="MS-Test158"  # The new name you want to use

TOKEN="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" # Github Personal Access Token

# for oldName in $REPO; do
#   # Function to generate newName from oldName
#   newName="$(echo $oldName| sed -e 's@MS-Test15@MS-Test151@g')"
echo ">> Renaming $oldName to $newName"

curl \
-H "Authorization: Token ${TOKEN}" \
-H "Content-Type:application/json" \
-H "Accept: application/json" \
-X PATCH \
--data "{ \"name\": \"${newName}\" }" \
https://api.github.com/repos/jrs-org/${oldName}

# Remove the old state entry for the repository
terraform state rm "module.repos.github_repository.repo_test[\"$oldName\"]"
terraform state rm "module.repos.github_branch.development[\"$oldName\"]"


# Import the new state entry for the repository
terraform import "module.repos.github_repository.repo_test[\"$newName\"]" "$newName"
terraform import "module.repos.github_branch.development[\"$newName\"]" "$newName:main"


# done
