# Retrieves current Azure client configuration (tenant ID, object ID, subscription ID)
data "azurerm_client_config" "current" {}

# Creates Azure Key Vault resource for OpenEMR secrets
resource "azurerm_key_vault" "openemr" {
  # Generates unique Key Vault name with random suffix (globally unique requirement)
  name                = "kv-openemr-dev-${random_string.suffix.result}"
  # Sets Azure region for Key Vault deployment
  location            = var.location
  # Assigns Key Vault to resource group
  resource_group_name = var.resource_group_name
  # Links Key Vault to Azure AD tenant
  tenant_id           = data.azurerm_client_config.current.tenant_id
  # Sets pricing tier (standard vs premium for HSM support)
  sku_name            = "standard"

  # Disables VM deployment access to secrets
  enabled_for_deployment          = false
  # Disables disk encryption access to secrets
  enabled_for_disk_encryption     = false
  # Allows ARM template deployments to retrieve secrets
  enabled_for_template_deployment = true
  # Prevents permanent deletion during retention period
  purge_protection_enabled        = true
  # Sets soft-delete recovery window in days
  soft_delete_retention_days      = 7

  # Configures network access restrictions
  network_acls {
    # Blocks all traffic by default
    default_action = "Deny"
    # Allows trusted Azure services through firewall
    bypass         = "AzureServices"
    # Whitelists admin IP address for access
    ip_rules       = [var.admin_ip]
  }

  # Applies resource tags for organization
  tags = var.tags
}

# Creates access policy for Terraform service principal/user
resource "azurerm_key_vault_access_policy" "terraform_sp" {
  # References the Key Vault created above
  key_vault_id = azurerm_key_vault.openemr.id
  # Links policy to Azure AD tenant
  tenant_id    = data.azurerm_client_config.current.tenant_id
  # Identifies the principal receiving permissions
  object_id    = data.azurerm_client_config.current.object_id

  # Grants secret management permissions
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge"
  ]
}

# Generates random string for unique resource naming
resource "random_string" "suffix" {
  # Sets character length for suffix
  length  = 4
  # Excludes special characters from suffix
  special = false
  # Forces lowercase characters only
  upper   = false
}

