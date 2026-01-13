variable "resource_group_name" {
  type        = string
  description = "Resource group name for Key Vault"
}

variable "sp_client_id" {
  type        = string
  description = "Service principal client ID"
  sensitive   = true
}

variable "sp_client_secret" {
  type        = string
  description = "Service principal client secret"
  sensitive   = true
}

variable "sp_tenant_id" {
  type        = string
  description = "Azure tenant ID"
  sensitive   = true
}

variable "admin_ip" {
  type        = string
  description = "Admin IP for Key Vault network ACL"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for resources"
}
 

variable "location" {
  type        = string
  description = "Azure region for Key Vault"
}
