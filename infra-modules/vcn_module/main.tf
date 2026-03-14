resource "oci_core_virtual_network" "vcn" {
    compartment_id = var.compartment_ocid
    cidr_block     = var.cidr_block
    dns_label      = var.dns_label
    display_name   = var.display_name
}