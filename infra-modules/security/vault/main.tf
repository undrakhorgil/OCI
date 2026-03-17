resource "oci_kms_vault" "vault" {
    compartment_id = var.compartment_ocid
    display_name   = var.display_name
    vault_type     = var.vault_type
}



