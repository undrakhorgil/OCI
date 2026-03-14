module "my_vcn01" {
    source            = "../../infra-modules/vcn_module"
    
    compartment_ocid  = var.compartment_ocid
    cidr_block        = var.vcn01_cidr_block
    dns_label         = var.vcn01_dns_label
    display_name      = var.vcn01_display_name  
}

module "my_vcn02" {
    source            = "../../infra-modules/vcn_module"

    compartment_ocid  = var.compartment_ocid
    cidr_block        = var.vcn02_cidr_block
    dns_label         = var.vcn02_dns_label
    display_name      = var.vcn02_display_name  
}