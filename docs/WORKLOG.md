## 2025-12-18

- Added Terraform provider configuration for AzureRM with explicit subscription handling.
- Created Resource Group `rg-openemr-dev-eus` in `eastus` via Azure CLI with baseline tags.
- Codified RG in `terraform/main.tf` as `azurerm_resource_group.openemr_dev` to make it reproducible.

