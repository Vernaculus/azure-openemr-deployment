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

}

resource "azurerm_resource_group" "openemr_dev" {
  name     = "rg-openemr-dev-eus"
  location = "eastus"

  tags = {
    env        = "dev"
    app        = "openemr"
    owner      = "Josh Hall"
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


