output "vault_prod_id" {
    value = module.prod_vault.vault_id
    sensitive = true
}
output "vault_dss_id" {
    value = module.dss_vault.vault_id
    sensitive = true
}
output "vault_management_endpoint_prod" {
    value = module.prod_vault.management_endpoint
    sensitive = true
}
output "vault_management_endpoint_dss" {
    value = module.dss_vault.management_endpoint
    sensitive = true
}