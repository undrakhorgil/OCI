resource "oci_identity_compartment" "compartment" {
    name          = var.name
    description   = var.description
    compartment_id = var.tenancy_ocid
    enable_delete = true
}