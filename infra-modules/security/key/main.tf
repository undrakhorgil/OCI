resource "oci_kms_key" "key" {
    compartment_id = var.compartment_ocid
    display_name   = var.display_name
    management_endpoint = var.management_endpoint
    protection_mode = var.protection_mode

    key_shape {
      algorithm = var.algorithm
      length = var.length
    }
}