module "prod_compartment" {
    source            = "../../infra-modules/compartment"
    
    name              = var.name_prod
    description       = var.description_prod

    tenancy_ocid      = var.tenancy_ocid
}

module "dss_compartment" {
    source            = "../../infra-modules/compartment"
    
    name              = var.name_dss
    description       = var.description_dss
    tenancy_ocid      = var.tenancy_ocid
}   