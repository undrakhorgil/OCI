# OCI Terraform Infrastructure

Terraform code for provisioning Oracle Cloud Infrastructure (OCI) resources. The repository uses a **modules + live** layout: reusable modules under `infra-modules/` and environment-specific usage under `infra-live/`.

## Repository Structure

```
OCI/
├── infra-modules/           # Reusable Terraform modules
│   ├── compartment/         # OCI Identity Compartment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vcn_module/          # OCI VCN + subnets + internet gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/            # OCI Autonomous Database (free tier)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/            # OCI Vault / Keys / Secrets
│       ├── vault/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── key/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── secret/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── infra-live/              # Live environments (consumes modules)
│   ├── compartment/        # Compartment stack (prod + dss)
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vcn/                # VCN stack (prod + dss VCNs with subnets and IGW)
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/           # Database stack (prod + dss Autonomous DBs)
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/           # Security stacks (Vault → Key → Secret)
│       ├── vault/
│       │   ├── main.tf
│       │   ├── provider.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── key/
│       │   ├── main.tf
│       │   ├── provider.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── secret/
│           ├── main.tf
│           ├── provider.tf
│           ├── variables.tf
│           └── outputs.tf
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed (code pins `required_version = ">= 1.6.0"` in `infra-live/*/provider.tf`)
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
| `tenancy_ocid`   | Tenancy OCID (parent)          |

**Outputs:** `compartment_id`, `compartment_name`

### 2. VCN (`infra-modules/vcn_module`)

Creates a Virtual Cloud Network with a public subnet, a private subnet, and an internet gateway.

| Variable                        | Description                    |
|---------------------------------|--------------------------------|
| `compartment_ocid`              | Target compartment             |
| `cidr_block`                    | VCN CIDR (e.g. 10.0.0.0/16)    |
| `dns_label`                    | DNS label for the VCN          |
| `display_name`                 | Display name for the VCN       |
| `public_subnet_cidr_block`     | CIDR for public subnet        |
| `public_subnet_display_name`   | Display name for public subnet |
| `private_subnet_cidr_block`    | CIDR for private subnet       |
| `private_subnet_display_name`  | Display name for private subnet|
| `internet_gateway_display_name`| Display name for internet gateway |

**Outputs:** `vcn_id`, `vcn_cidr_block`, `vcn_display_name`, `vcn_dns_label`, `public_subnet_id`, `private_subnet_id`, `internet_gateway_id`

### 3. Database (`infra-modules/database`)

Creates an OCI Autonomous Database (free tier).

| Variable          | Description                    |
|-------------------|--------------------------------|
| `compartment_ocid`| Target compartment             |
| `db_name`         | Database name                  |
| `display_name`    | Display name                   |
| `workload_type`   | DB workload (e.g. OLTP, DW)    |
| `admin_password`  | Admin password (sensitive)     |

**Outputs:** `db_id`, `db_name`, `db_display_name`, `db_workload`

### 4. Security: Vault / Key / Secret (`infra-modules/security/*`)

#### Vault module (`infra-modules/security/vault`)

Creates an OCI KMS Vault.

| Variable           | Description                       |
|--------------------|-----------------------------------|
| `compartment_ocid` | Target compartment                |
| `display_name`     | Vault display name                |
| `vault_type`       | Vault type (default: `SOFTWARE`)  |

**Outputs:** `vault_id`, `management_endpoint`

#### Key module (`infra-modules/security/key`)

Creates an OCI KMS Key inside a Vault (requires the vault `management_endpoint`).

| Variable              | Description                              |
|-----------------------|------------------------------------------|
| `compartment_ocid`    | Target compartment                       |
| `display_name`        | Key display name                         |
| `management_endpoint` | Vault management endpoint (sensitive)    |
| `algorithm`           | Key algorithm (default: `AES`)           |
| `length`              | Key length (default: `32`)               |
| `protection_mode`     | Protection mode (default: `SOFTWARE`)    |

**Outputs:** `key_id`

#### Secret module (`infra-modules/security/secret`)

Creates an OCI Vault Secret (used here to store DB admin passwords). The module encodes the password using `BASE64`.

| Variable           | Description                   |
|--------------------|-------------------------------|
| `compartment_ocid` | Target compartment            |
| `secret_name`      | Secret name                   |
| `vault_id`         | Vault OCID (sensitive)        |
| `key_id`           | Key OCID (sensitive)          |
| `admin_password`   | Secret content (sensitive)    |

**Outputs:** `db_password_secret_id`

## Live Stacks

### Compartment stack (`infra-live/compartment`)

- **prod_compartment** – production compartment  
- **dss_compartment** – DSS compartment  

| Variable            | Description                          |
|---------------------|--------------------------------------|
| `name_prod`         | Production compartment name          |
| `description_prod`  | Production compartment description   |
| `name_dss`          | DSS compartment name                 |
| `description_dss`   | DSS compartment description           |
| `tenancy_ocid`      | Tenancy OCID                         |

Provide these via `terraform.tfvars`, `.tfvars` files, or environment variables.

### VCN stack (`infra-live/vcn`)

- **my_vcn_prod** – VCN in production compartment (with public subnet, private subnet, internet gateway)  
- **my_vcn_dss** – VCN in DSS compartment (with public subnet, private subnet, internet gateway)  

Compartment IDs are read from the compartment stack via **Terraform remote state** (local backend: `../compartment/terraform.tfstate`). Apply the compartment stack first and keep its state so the VCN stack can read it.

| Variable                               | Description                          |
|----------------------------------------|--------------------------------------|
| `vcn_prod_cidr_block`                  | CIDR for prod VCN (e.g. 10.0.0.0/16)  |
| `vcn_prod_display_name`                | Display name for prod VCN            |
| `vcn_prod_dns_label`                   | DNS label for prod VCN               |
| `vcn_prod_public_subnet_cidr_block`    | CIDR for prod public subnet          |
| `vcn_prod_public_subnet_display_name`  | Display name for prod public subnet  |
| `vcn_prod_private_subnet_cidr_block`   | CIDR for prod private subnet         |
| `vcn_prod_private_subnet_display_name` | Display name for prod private subnet |
| `vcn_prod_internet_gateway_display_name` | Display name for prod IGW          |
| `vcn_dss_cidr_block`                   | CIDR for DSS VCN                     |
| `vcn_dss_display_name`                 | Display name for DSS VCN             |
| `vcn_dss_dns_label`                    | DNS label for DSS VCN                |
| `vcn_dss_public_subnet_cidr_block`     | CIDR for DSS public subnet           |
| `vcn_dss_public_subnet_display_name`   | Display name for DSS public subnet   |
| `vcn_dss_private_subnet_cidr_block`    | CIDR for DSS private subnet          |
| `vcn_dss_private_subnet_display_name`  | Display name for DSS private subnet  |
| `vcn_dss_internet_gateway_display_name`| Display name for DSS IGW             |

**Outputs:** `vcn_prod_id`, `vcn_prod_cidr_block`, `vcn_prod_display_name`, `vcn_prod_dns_label`, `vcn_prod_public_subnet_id`, `vcn_prod_private_subnet_id`, `vcn_prod_internet_gateway_id`, and the same set for `vcn_dss_*`.

### Database stack (`infra-live/database`)

- **my_db_prod** – Autonomous Database in production compartment  
- **my_db_dss** – Autonomous Database in DSS compartment  

This stack reads compartment IDs from the compartment stack via **Terraform remote state** (`../compartment/terraform.tfstate`) and reads DB admin passwords from the **security secret stack** (`../security/secret/terraform.tfstate`) using `oci_secrets_secretbundle`. Apply the compartment stack and security secret stack first.

| Variable                  | Description                    |
|---------------------------|--------------------------------|
| `db_prod_name`            | Prod database name            |
| `db_prod_display_name`    | Prod database display name    |
| `db_prod_workload_type`   | Prod workload (e.g. OLTP, DW)  |
| `db_dss_name`             | DSS database name             |
| `db_dss_display_name`     | DSS database display name     |
| `db_dss_workload_type`    | DSS workload (e.g. OLTP, DW)   |

**Outputs:** `db_prod_id`, `db_prod_name`, `db_prod_display_name`, `db_dss_id`, `db_dss_name`, `db_dss_display_name`

### Security stacks (`infra-live/security/*`)

Security is split into three stacks with dependencies via local remote state:

- **Vault** (`infra-live/security/vault`): reads `../../compartment/terraform.tfstate`
- **Key** (`infra-live/security/key`): reads `../../compartment/terraform.tfstate` and `../../security/vault/terraform.tfstate`
- **Secret** (`infra-live/security/secret`): reads `../../compartment/terraform.tfstate`, `../../security/vault/terraform.tfstate`, and `../../security/key/terraform.tfstate`

#### Vault stack (`infra-live/security/vault`)

Creates a vault for prod and dss.

| Variable                  | Description                     |
|---------------------------|---------------------------------|
| `prod_vault_display_name` | Prod vault display name         |
| `prod_vault_type`         | Prod vault type (default: `SOFTWARE`) |
| `dss_vault_display_name`  | DSS vault display name          |
| `dss_vault_type`          | DSS vault type (default: `SOFTWARE`) |

**Outputs:** `vault_prod_id`, `vault_dss_id`, `vault_management_endpoint_prod`, `vault_management_endpoint_dss`

#### Key stack (`infra-live/security/key`)

Creates a KMS key for prod and dss (uses vault management endpoints from the vault stack).

| Variable                   | Description                         |
|----------------------------|-------------------------------------|
| `prod_key_display_name`    | Prod key display name               |
| `prod_key_algorithm`       | Prod key algorithm (default: `AES`) |
| `prod_key_length`          | Prod key length (default: `32`)     |
| `prod_key_protection_mode` | Prod protection mode (default: `SOFTWARE`) |
| `dss_key_display_name`     | DSS key display name                |
| `dss_key_algorithm`        | DSS key algorithm (default: `AES`)  |
| `dss_key_length`           | DSS key length (default: `32`)      |
| `dss_key_protection_mode`  | DSS protection mode (default: `SOFTWARE`) |

**Outputs:** `key_prod_id`, `key_dss_id`

#### Secret stack (`infra-live/security/secret`)

Creates two secrets (DB admin passwords), one for prod and one for dss.

| Variable                     | Description                    |
|------------------------------|--------------------------------|
| `prod_db_secret_display_name`| Prod secret name               |
| `prod_db_admin_password`     | Prod DB admin password (sensitive) |
| `dss_db_secret_display_name` | DSS secret name                |
| `dss_db_admin_password`      | DSS DB admin password (sensitive) |

**Outputs:** `prod_db_secret_id`, `dss_db_secret_id`

## Usage

1. **Configure OCI CLI** (if not already):
   ```bash
   oci setup config
   ```
   Use the profile name `DEFAULT` or update `config_file_profile` in `provider.tf`.

2. **Compartment stack** (run first; state is required for all other stacks)
   ```bash
   cd infra-live/compartment
   terraform init
   terraform plan
   terraform apply
   ```
   State is stored locally and is consumed via `terraform_remote_state` by other stacks—do not delete or move it before applying dependent stacks.

3. **Security vault stack**
   ```bash
   cd infra-live/security/vault
   terraform init
   terraform plan
   terraform apply
   ```

4. **Security key stack**
   ```bash
   cd infra-live/security/key
   terraform init
   terraform plan
   terraform apply
   ```

5. **Security secret stack**
   ```bash
   cd infra-live/security/secret
   terraform init
   terraform plan
   terraform apply
   ```

6. **VCN stack**
   ```bash
   cd infra-live/vcn
   terraform init
   terraform plan
   terraform apply
   ```
   Run from `infra-live/vcn` so the remote state path to `../compartment/terraform.tfstate` resolves correctly.

7. **Database stack**
   ```bash
   cd infra-live/database
   terraform init
   terraform plan
   terraform apply
   ```
   Run from `infra-live/database` so remote state paths resolve correctly. This stack depends on the security secret stack (`../security/secret/terraform.tfstate`) to fetch DB admin passwords.

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
vcn_prod_public_subnet_cidr_block   = "10.0.1.0/24"
vcn_prod_public_subnet_display_name = "vcnprod-pub"
vcn_prod_private_subnet_cidr_block   = "10.0.2.0/24"
vcn_prod_private_subnet_display_name = "vcnprod-priv"
vcn_prod_internet_gateway_display_name = "vcnprod-igw"

vcn_dss_cidr_block    = "172.16.0.0/16"
vcn_dss_display_name  = "vcndss"
vcn_dss_dns_label     = "vcndss"
vcn_dss_public_subnet_cidr_block   = "172.16.1.0/24"
vcn_dss_public_subnet_display_name = "vcndss-pub"
vcn_dss_private_subnet_cidr_block   = "172.16.2.0/24"
vcn_dss_private_subnet_display_name = "vcndss-priv"
vcn_dss_internet_gateway_display_name = "vcndss-igw"
```

**infra-live/database/terraform.tfvars.example:**
```hcl
db_prod_name          = "dbprod"
db_prod_display_name  = "Production DB"
db_prod_workload_type = "OLTP"

db_dss_name           = "dbdss"
db_dss_display_name   = "DSS DB"
db_dss_workload_type  = "DW"
```

**infra-live/security/vault/terraform.tfvars.example:**
```hcl
prod_vault_display_name = "vault-prod"
dss_vault_display_name  = "vault-dss"
prod_vault_type = "SOFTWARE"
dss_vault_type  = "SOFTWARE"
```

**infra-live/security/key/terraform.tfvars.example:**
```hcl
prod_key_display_name = "key-prod"
dss_key_display_name  = "key-dss"

# Optional (defaults shown)
prod_key_algorithm = "AES"
prod_key_length    = 32
prod_key_protection_mode = "SOFTWARE"

dss_key_algorithm = "AES"
dss_key_length    = 32
dss_key_protection_mode = "SOFTWARE"
```

**infra-live/security/secret/terraform.tfvars.example:**
```hcl
prod_db_secret_display_name = "db-prod-admin-password"
# prod_db_admin_password = "YourSecurePassword123!"

dss_db_secret_display_name = "db-dss-admin-password"
# dss_db_admin_password = "YourSecurePassword123!"
```

## Notes

- **Authentication:** All stacks use `config_file_profile = "DEFAULT"`. Ensure `~/.oci/config` is set up (e.g. `oci setup config`); no credential variables are required for the provider.
- Compartment module uses `enable_delete = true` so compartments can be destroyed via Terraform; use with care in production.
- **Apply order:** Compartment → security/vault → security/key → security/secret → (VCN anytime after compartment) → database.
- Database module creates **free tier** Autonomous Databases (`is_free_tier = true`).
- Do not commit real `terraform.tfvars` or passwords; use a `.gitignore` for secrets and consider remote state (e.g. OCI Object Storage backend) for production.
