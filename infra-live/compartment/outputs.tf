output "compartment_prod_id" {
    value = module.prod_compartment.compartment_id
    sensitive = true
}   
output "compartment_prod_name" {
    value = module.prod_compartment.compartment_name
}
output "compartment_dss_id" {
    value = module.dss_compartment.compartment_id
    sensitive = true
}   
output "compartment_dss_name" {
    value = module.dss_compartment.compartment_name    
}

