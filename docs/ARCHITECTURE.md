### Tagging Strategy

**Purpose**  
Tags provide standardized metadata across all Azure resources for cost management, ownership tracking, automation, and compliance classification. This ensures operational consistency and visibility across healthcare and finance workloads under HIPAA and PCI-DSS.

**Tag Schema**

| Tag Key | Purpose | Example Value | Required |
|----------|----------|---------------|-----------|
| `env` | Environment stage | `dev` | Yes |
| `app` | Application or workload name | `openemr` | Yes |
| `owner` | Responsible team or operational group | `cloud-ops` | Yes |
| `costCenter` | Billing or operational cost allocation | `platform-ops` | Yes |
| `compliance` | Regulatory or governance scope | `hipaa-pcidss` | Yes |
| `dataClassification` | Data sensitivity identifier | `phi-pci` | Yes |
| `project` | Broader initiative grouping | `azure-healthcare-platform` | Optional |
| `createdBy` | Deployment or automation source | `terraform` | Optional |

**Implementation**

- Defined in Terraform under `locals.common_tags` and applied consistently across all resources.
- Inherited automatically by modules and merged where needed using `merge(local.common_tags, {...})`.
- Applied at the resource group and resource level to ensure consistent cost, compliance, and ownership visibility.

**Example Terraform Implementation**

```hcl
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

resource "azurerm_resource_group" "openemr_dev" {
  name     = "rg-openemr-dev-eus"
  location = "eastus"
  tags     = local.common_tags
}

# Resource Group: rg-openemr-dev-eus

**What:**  
Azure Resource Group in `eastus` that contains all dev resources for the OpenEMR workload.

**Why:**

- Workload-centric RG so all OpenEMR components (network, compute, storage, DB) share a lifecycle and can be managed together.
- Name encodes app, env, and region for clarity and scale: `rg-openemr-dev-eus`, following Azure naming guidance.
- Tags (`env`, `app`, `owner`, `costCenter`, `compliance`) support cost reporting, ownership tracking, and compliance filtering (HIPAA/PCI-related workloads).

**Implemented by:**

- Terraform: `terraform/main.tf` → `azurerm_resource_group.openemr_dev`.
- Azure CLI (initial bootstrap, one-time):  
  `az group create --name rg-openemr-dev-eus --location eastus --tags env=dev app=openemr owner="Josh Hall" costCenter=personal-lab compliance=hipaa-pcidss`.

### Budget and Cost Alerts

**Purpose:**  
Proactive cost monitoring to prevent unexpected charges and enforce financial discipline for the OpenEMR platform.

**Implementation:**

- **Scope:** Resource group `rg-openemr-dev-eus`.
- **Budget:** $50/month.
- **Alerts:**
  - 50% actual spend → Azure mobile app push + email.
  - 80% actual spend → Azure mobile app push + email.
  - 100% forecasted spend → Azure mobile app push + email.
- **Tooling:** Defined in Terraform (`terraform/monitoring.tf`), using variables for email (stored in `terraform.tfvars`, not committed).
- **Notification channels:** Azure mobile app (iOS) + email backup.

**Future Enhancements:**

- Expand to tag-based budgets for multi-environment tracking (`env=test`, `env=prod`).
- Integrate with Logic Apps to auto-shutdown dev resources when budget is breached.

