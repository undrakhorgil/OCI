terraform {
  required_version = ">= 1.6.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}
# Use existing OCI CLI config: credentials from ~/.oci/config profile [DEFAULT]
# (tenancy_ocid, user_ocid, fingerprint, key_file). No need to pass them in Terraform.
provider "oci" {
    config_file_profile = "DEFAULT"
}