data "terraform_remote_state" "compartment" {
  backend = "local"

  config = {
    path = "${path.root}/../compartment/terraform.tfstate"
  }
}

module "my_vcn_prod" {
    source            = "../../infra-modules/vcn_module"

    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_prod_id
    cidr_block        = var.vcn_prod_cidr_block
    dns_label         = var.vcn_prod_dns_label
    display_name      = var.vcn_prod_display_name  
}

module "my_vcn_dss" {
    source            = "../../infra-modules/vcn_module"

    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    cidr_block        = var.vcn_dss_cidr_block
    dns_label         = var.vcn_dss_dns_label
    display_name      = var.vcn_dss_display_name  
}