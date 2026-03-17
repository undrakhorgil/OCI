output "key_prod_id" {
    value = module.prod_key.key_id
    sensitive = true
}
output "key_dss_id" {
    value = module.dss_key.key_id
    sensitive = true
}