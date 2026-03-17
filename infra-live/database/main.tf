data "terraform_remote_state" "compartment" {
  backend = "local"

  config = {
    path = "${path.root}/../compartment/terraform.tfstate"
  }
}

data "terraform_remote_state" "secret" {
  backend = "local"

  config = {
    path = "${path.root}/../security/secret/terraform.tfstate"
  }
}

# DSS DB password
data "oci_secrets_secretbundle" "dss_db_password" {
  secret_id = data.terraform_remote_state.secret.outputs.dss_db_secret_id
}

# PROD DB password
data "oci_secrets_secretbundle" "prod_db_password" {
  secret_id = data.terraform_remote_state.secret.outputs.prod_db_secret_id
}

locals {
  dss_admin_password  = data.oci_secrets_secretbundle.dss_db_password.secret_bundle_content[0].content
  prod_admin_password = data.oci_secrets_secretbundle.prod_db_password.secret_bundle_content[0].content
} 

module "my_db_prod" {
    source            = "../../infra-modules/database"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_prod_id
    db_name           = var.db_prod_name
    display_name      = var.db_prod_display_name
    workload_type     = var.db_prod_workload_type
    admin_password    = local.prod_admin_password
}

module "my_db_dss" {
    source            = "../../infra-modules/database"
    compartment_ocid  = data.terraform_remote_state.compartment.outputs.compartment_dss_id
    db_name           = var.db_dss_name
    display_name      = var.db_dss_display_name
    workload_type     = var.db_dss_workload_type
    admin_password    = local.dss_admin_password
}