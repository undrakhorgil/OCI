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
│   │   └── variables.tf
│   └── vcn/                # VCN stack (two VCNs)
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed (compatible with OCI provider)
- OCI account and CLI config (e.g. `~/.oci/config`) with a profile (default: `DEFAULT`)
- Required OCI credentials: tenancy OCID, user OCID, fingerprint, private key path (for API auth)

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

- **my_vcn01** – first VCN  
- **my_vcn02** – second VCN  

| Variable             | Description            |
|----------------------|------------------------|
| `region`             | OCI region             |
| `tenancy_ocid`       | Tenancy OCID           |
| `user_ocid`          | User OCID              |
| `fingerprint`        | API key fingerprint    |
| `private_key_path`   | Path to private key    |
| `compartment_ocid`   | Compartment for VCNs   |
| `vcn01_cidr_block`   | CIDR for first VCN     |
| `vcn01_display_name` | Display name for first VCN |
| `vcn01_dns_label`    | DNS label for first VCN |
| `vcn02_cidr_block`   | CIDR for second VCN    |
| `vcn02_display_name`| Display name for second VCN |
| `vcn02_dns_label`    | DNS label for second VCN |

Create the compartment(s) first, then use the compartment OCID in the VCN stack (e.g. via `compartment_ocid` in `terraform.tfvars`).

## Usage

1. **Configure OCI CLI** (if not already):
   ```bash
   oci setup config
   ```
   Use the profile name `DEFAULT` or update `config_file_profile` in `provider.tf`.

2. **Compartment stack**
   ```bash
   cd infra-live/compartment
   terraform init
   terraform plan
   terraform apply
   ```
   Capture the compartment OCID(s) from outputs for use in the VCN stack.

3. **VCN stack**
   ```bash
   cd infra-live/vcn
   terraform init
   terraform plan
   terraform apply
   ```

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
compartment_ocid   = "ocid1.compartment.oc1....."
vcn01_cidr_block  = "10.0.0.0/16"
vcn01_display_name = "my-vcn-01"
vcn01_dns_label   = "vcn01"
vcn02_cidr_block  = "10.1.0.0/16"
vcn02_display_name = "my-vcn-02"
vcn02_dns_label   = "vcn02"
```

## Notes

- Compartment module uses `enable_delete = true` so compartments can be destroyed via Terraform; use with care in production.
- Apply the compartment stack before the VCN stack so `compartment_ocid` exists.
- Do not commit real `terraform.tfvars` or private keys; use a `.gitignore` for secrets and consider remote state (e.g. OCI Object Storage backend).
