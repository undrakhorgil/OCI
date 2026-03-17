output "db_password_secret_id" {
    value = oci_vault_secret.db_password_secret.id
    sensitive = true
}