data "terraform_remote_state" "compartment" {
  backend = "local"

  config = {
    path = "${path.root}/../../compartment/terraform.tfstate"
  }
}

module "prod_vault" {
    source            = "../../../infra-modules/security/vault"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_prod_id
    display_name      = var.prod_vault_display_name
    vault_type        = var.prod_vault_type
}

module "dss_vault" {
    source            = "../../../infra-modules/security/vault"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    display_name      = var.dss_vault_display_name
    vault_type        = var.dss_vault_type
}
