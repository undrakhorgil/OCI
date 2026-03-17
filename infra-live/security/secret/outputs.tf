output "prod_db_secret_id" {
    value = module.prod_db_secret.db_password_secret_id
    sensitive = true
}
output "dss_db_secret_id" {
    value = module.dss_db_secret.db_password_secret_id
    sensitive = true
}