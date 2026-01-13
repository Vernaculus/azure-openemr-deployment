# Stores Terraform service principal client ID (app ID) in Key Vault
resource "azurerm_key_vault_secret" "sp_client_id" {
  # Secret name as it appears in Key Vault
  name         = "terraform-sp-client-id"
  # Service principal client ID value from variable
  value        = var.sp_client_id
  # References the OpenEMR Key Vault resource
  key_vault_id = azurerm_key_vault.openemr.id

  # Ensures access policy exists before creating secret
  depends_on = [azurerm_key_vault_access_policy.terraform_sp]
}

# Stores Terraform service principal client secret (password) in Key Vault
resource "azurerm_key_vault_secret" "sp_client_secret" {
  # Secret name as it appears in Key Vault
  name         = "terraform-sp-client-secret"
  # Service principal client secret value from variable
  value        = var.sp_client_secret
  # References the OpenEMR Key Vault resource
  key_vault_id = azurerm_key_vault.openemr.id

  # Ensures access policy exists before creating secret
  depends_on = [azurerm_key_vault_access_policy.terraform_sp]
}

# Stores Azure AD tenant ID in Key Vault
resource "azurerm_key_vault_secret" "sp_tenant_id" {
  # Secret name as it appears in Key Vault
  name         = "terraform-sp-tenant-id"
  # Tenant ID value from variable
  value        = var.sp_tenant_id
  # References the OpenEMR Key Vault resource
  key_vault_id = azurerm_key_vault.openemr.id

  # Ensures access policy exists before creating secret
  depends_on = [azurerm_key_vault_access_policy.terraform_sp]
}

