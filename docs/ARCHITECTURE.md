### Resource Group: rg-openemr-dev-eus

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

