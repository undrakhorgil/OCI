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
    public_subnet_cidr_block = var.vcn_prod_public_subnet_cidr_block
    public_subnet_display_name = var.vcn_prod_public_subnet_display_name
    private_subnet_cidr_block = var.vcn_prod_private_subnet_cidr_block
    private_subnet_display_name = var.vcn_prod_private_subnet_display_name
    internet_gateway_display_name = var.vcn_prod_internet_gateway_display_name
}

module "my_vcn_dss" {
    source            = "../../infra-modules/vcn_module"

    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    cidr_block        = var.vcn_dss_cidr_block
    dns_label         = var.vcn_dss_dns_label
    display_name      = var.vcn_dss_display_name  
    public_subnet_cidr_block = var.vcn_dss_public_subnet_cidr_block
    public_subnet_display_name = var.vcn_dss_public_subnet_display_name
    private_subnet_cidr_block = var.vcn_dss_private_subnet_cidr_block
    private_subnet_display_name = var.vcn_dss_private_subnet_display_name
    internet_gateway_display_name = var.vcn_dss_internet_gateway_display_name
}