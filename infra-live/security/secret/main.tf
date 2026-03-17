data "terraform_remote_state" "compartment" {
  backend = "local"

  config = {
    path = "${path.root}/../../compartment/terraform.tfstate"
  }
}

data "terraform_remote_state" "vault" {
  backend = "local"

  config = {
    path = "${path.root}/../../security/vault/terraform.tfstate"
  }
}

data "terraform_remote_state" "key" {
  backend = "local"

  config = {
    path = "${path.root}/../../security/key/terraform.tfstate"
  }
}

module "prod_db_secret" {
    source            = "../../../infra-modules/security/secret"
    secret_name       = var.prod_db_secret_display_name
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_prod_id
    key_id            = data.terraform_remote_state.key.outputs.key_prod_id
    vault_id          = data.terraform_remote_state.vault.outputs.vault_prod_id
    admin_password    = var.prod_db_admin_password
}

module "dss_db_secret" {
    source            = "../../../infra-modules/security/secret"
    secret_name       = var.dss_db_secret_display_name
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    key_id            = data.terraform_remote_state.key.outputs.key_dss_id
    vault_id          = data.terraform_remote_state.vault.outputs.vault_dss_id
    admin_password    = var.dss_db_admin_password
}
