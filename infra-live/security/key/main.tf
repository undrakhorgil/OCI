data "terraform_remote_state" "vault" {
  backend = "local"

  config = {
    path = "${path.root}/../../security/vault/terraform.tfstate"
  }
}

data "terraform_remote_state" "compartment" {
  backend = "local"

  config = {
    path = "${path.root}/../../compartment/terraform.tfstate"
  }
}

module "prod_key" {
    source            = "../../../infra-modules/security/key"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_prod_id
    management_endpoint = data.terraform_remote_state.vault.outputs.vault_management_endpoint_prod
    display_name      = var.prod_key_display_name
    protection_mode   = var.prod_key_protection_mode
    algorithm         = var.prod_key_algorithm
    length            = var.prod_key_length
}

module "dss_key" {
    source            = "../../../infra-modules/security/key"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    management_endpoint = data.terraform_remote_state.vault.outputs.vault_management_endpoint_dss
    display_name      = var.dss_key_display_name
    protection_mode   = var.dss_key_protection_mode
    algorithm         = var.dss_key_algorithm
    length            = var.dss_key_length
}
