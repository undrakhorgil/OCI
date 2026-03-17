resource "oci_core_virtual_network" "vcn" {
    compartment_id = var.compartment_ocid
    cidr_block     = var.cidr_block
    dns_label      = var.dns_label
    display_name   = var.display_name
}

resource "oci_core_subnet" "public_subnet" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    cidr_block     = var.public_subnet_cidr_block
    display_name   = var.public_subnet_display_name
}

resource "oci_core_subnet" "private_subnet" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    cidr_block     = var.private_subnet_cidr_block
    display_name   = var.private_subnet_display_name
}

resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = var.internet_gateway_display_name
}