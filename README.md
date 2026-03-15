# OCI Terraform Infrastructure

Terraform code for provisioning Oracle Cloud Infrastructure (OCI) resources. The repository uses a **modules + live** layout: reusable modules under `infra-modules/` and environment-specific usage under `infra-live/`.

## Repository Structure

```
OCI/
├── infra-modules/           # Reusable Terraform modules
│   ├── compartment/         # OCI Identity Compartment
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── outputs.tf
│   └── vcn_module/          # OCI Virtual Cloud Network
│       ├── main.tf
│       ├── variable.tf
│       └── outputs.tf
├── infra-live/              # Live environments (consumes modules)
│   ├── compartment/        # Compartment stack (prod + dss)
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vcn/                # VCN stack (prod + dss VCNs)
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed (compatible with OCI provider)
- OCI CLI config file (e.g. `~/.oci/config`) with the `[DEFAULT]` profile populated. Authentication is read from this file; no credentials need to be passed as Terraform variables.

## Provider

- **Provider:** `oracle/oci`
- **Config:** Uses `config_file_profile = "DEFAULT"` (see `infra-live/*/provider.tf`).

**What `config_file_profile = "DEFAULT"` does:** Terraform uses your **already configured** OCI CLI config file (usually `~/.oci/config`). It reads the `[DEFAULT]` profile from that file for authentication—tenancy OCID, user OCID, fingerprint, and private key path (`key_file`). You do **not** need to pass those credentials as Terraform variables; they are taken from the config file. Ensure the `DEFAULT` profile in `~/.oci/config` is populated (e.g. via `oci setup config`) before running `terraform plan` or `apply`.

## Modules

### 1. Compartment (`infra-modules/compartment`)

Creates a single OCI Identity Compartment under the tenancy.

| Variable         | Description                    |
|------------------|--------------------------------|
| `name`           | Compartment name               |
| `description`    | Compartment description        |
| `tenancy_ocid`   | Tenancy OCID (parent)         |

**Outputs:** `compartment_id`, `compartment_name`

### 2. VCN (`infra-modules/vcn_module`)

Creates a single Virtual Cloud Network.

| Variable          | Description           |
|-------------------|-----------------------|
| `compartment_ocid`| Target compartment    |
| `cidr_block`      | VCN CIDR (e.g. 10.0.0.0/16) |
| `dns_label`       | DNS label for the VCN |
| `display_name`    | Display name          |

**Outputs:** `vcn_id`, `vcn_cidr_block`, `vcn_display_name`, `vcn_dns_label`

## Live Stacks

### Compartment stack (`infra-live/compartment`)

- **prod_compartment** – production compartment  
- **dss_compartment** – DSS compartment  

| Variable            | Description              |
|---------------------|--------------------------|
| `name_prod`         | Production compartment name |
| `description_prod`  | Production compartment description |
| `name_dss`          | DSS compartment name     |
| `description_dss`   | DSS compartment description |
| `tenancy_ocid`      | Tenancy OCID             |

Provide these via `terraform.tfvars`, `.tfvars` files, or environment variables.

### VCN stack (`infra-live/vcn`)

- **my_vcn_prod** – VCN in the production compartment  
- **my_vcn_dss** – VCN in the DSS compartment  

Compartment IDs are read from the compartment stack via **Terraform remote state** (local backend: `../compartment/terraform.tfstate`). You do not pass `compartment_ocid`; apply the compartment stack first and keep its state so the VCN stack can read it.

| Variable               | Description                    |
|------------------------|--------------------------------|
| `vcn_prod_cidr_block`  | CIDR for prod VCN (e.g. 10.0.0.0/16) |
| `vcn_prod_display_name` | Display name for prod VCN    |
| `vcn_prod_dns_label`  | DNS label for prod VCN        |
| `vcn_dss_cidr_block`  | CIDR for DSS VCN              |
| `vcn_dss_display_name`| Display name for DSS VCN      |
| `vcn_dss_dns_label`   | DNS label for DSS VCN         |

## Usage

1. **Configure OCI CLI** (if not already):
   ```bash
   oci setup config
   ```
   Use the profile name `DEFAULT` or update `config_file_profile` in `provider.tf`.

2. **Compartment stack** (run first; state is required for the VCN stack)
   ```bash
   cd infra-live/compartment
   terraform init
   terraform plan
   terraform apply
   ```
   State is stored locally. The VCN stack reads compartment IDs from this state via a local backend—do not delete or move the compartment state before applying the VCN stack.

3. **VCN stack**
   ```bash
   cd infra-live/vcn
   terraform init
   terraform plan
   terraform apply
   ```
   Ensure you run this from `infra-live/vcn` so the remote state path to `../compartment/terraform.tfstate` resolves correctly.

## Example `terraform.tfvars`

**infra-live/compartment/terraform.tfvars.example:**
```hcl
tenancy_ocid     = "ocid1.tenancy.oc1....."
name_prod        = "prod-compartment"
description_prod = "Production compartment"
name_dss         = "dss-compartment"
description_dss  = "DSS compartment"
```

**infra-live/vcn/terraform.tfvars.example:**
```hcl
vcn_prod_cidr_block   = "10.0.0.0/16"
vcn_prod_display_name = "vcnprod"
vcn_prod_dns_label    = "vcnprod"

vcn_dss_cidr_block    = "172.16.0.0/16"
vcn_dss_display_name  = "vcndss"
vcn_dss_dns_label     = "vcndss"
```

## Notes

- **Authentication:** Both stacks use `config_file_profile = "DEFAULT"`. Ensure `~/.oci/config` is set up (e.g. `oci setup config`); no credential variables are required for the provider.
- Compartment module uses `enable_delete = true` so compartments can be destroyed via Terraform; use with care in production.
- Apply the compartment stack before the VCN stack. The VCN stack reads compartment IDs from the compartment state (local backend at `../compartment/terraform.tfstate`).
- Do not commit real `terraform.tfvars` or private keys; use a `.gitignore` for secrets and consider remote state (e.g. OCI Object Storage backend) for production.
