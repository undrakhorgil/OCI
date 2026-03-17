output "vault_id" {
    value = oci_kms_vault.vault.id
    sensitive = true
}
output "management_endpoint" {
    value = oci_kms_vault.vault.management_endpoint
    sensitive = true
}