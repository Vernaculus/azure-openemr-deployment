# Create main Resource Group

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Disable automatic provider registration since the SP lacks subscription-level rights
  resource_provider_registrations = "none"
  subscription_id                 = "316876d9-f38d-4fd5-8371-f0be2df0eb1a"

}

resource "azurerm_resource_group" "openemr_dev" {
  name     = "rg-openemr-dev-eus"
  location = "eastus"

  tags = {
    env        = "dev"
    app        = "openemr"
    owner      = "cloud-ops"
    costCenter = "platform-ops"
    compliance = "hipaa-pcidss"
  }
}

# Established tag scheme

locals {
  common_tags = {
    env                = "dev"
    app                = "openemr"
    owner              = "cloud-ops"
    costCenter         = "platform-ops"
    compliance         = "hipaa-pcidss"
    dataClassification = "phi-pci"
    project            = "azure-healthcare-platform"
    createdBy          = "terraform"
  }
}

# Action Group for budget alerts (Azure mobile app push notifications)
resource "azurerm_monitor_action_group" "budget_alerts" {
  name                = "ag-budget-alerts-openemr"
  resource_group_name = azurerm_resource_group.openemr_dev.name
  short_name          = "budgetalrt"

  azure_app_push_receiver {
    name          = "azure-app-push"
    email_address = var.alert_email # Email tied to Azure Account/mobile app. Reference variable instead of hardcoding
  }

  # Email receiver as backup
  email_receiver {
    name          = "email-backup"
    email_address = var.alert_email # Reference variable instead of hardcoding.
  }

  tags = local.common_tags
}

# Consumption Budget for the OpenEMR dev resource group
resource "azurerm_consumption_budget_resource_group" "openemr_dev_budget" {
  name              = "budget-openemr-dev-monthly"
  resource_group_id = azurerm_resource_group.openemr_dev.id

  amount     = 50 # Budget in USD
  time_grain = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }

  # Alert at 50% actual spend
  notification {
    enabled   = true
    threshold = 50
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.budget_alerts.id
    ]
  }

  # Alert at 80% actual spend
  notification {
    enabled   = true
    threshold = 80
    operator  = "GreaterThan"

    contact_groups = [
      azurerm_monitor_action_group.budget_alerts.id
    ]
  }

  # Alert at 100% forecasted spend
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_groups = [
      azurerm_monitor_action_group.budget_alerts.id
    ]
  }
}

# Calls the security module to create Key Vault and manage secrets
module "security" {
  # Path to the security module directory
  source = "./modules/security"

  # Passes resource group name from root module to security module
  resource_group_name = azurerm_resource_group.openemr_dev.name
  # Passes Azure region to security module
  location            = azurerm_resource_group.openemr_dev.location
  # Passes service principal client ID for Key Vault secret storage
  sp_client_id        = var.sp_client_id
  # Passes service principal client secret for Key Vault secret storage
  sp_client_secret    = var.sp_client_secret
  # Passes tenant ID for Key Vault secret storage
  sp_tenant_id        = var.sp_tenant_id
  # Passes admin IP for Key Vault firewall whitelist
  admin_ip            = var.admin_ip
  # Passes common tags from local values for resource tagging
  tags                = local.common_tags
}
 
