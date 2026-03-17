resource "oci_vault_secret" "db_password_secret" {
  compartment_id    = var.compartment_ocid
  secret_name       = var.secret_name
  vault_id          = var.vault_id
  key_id            = var.key_id

  secret_content {
    content_type = "BASE64"
    content      = base64encode(var.admin_password)
  }
}


