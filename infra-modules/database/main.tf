resource "oci_database_autonomous_database" "free_db" {
    compartment_id = var.compartment_ocid
    db_name       = var.db_name
    display_name  = var.display_name
    is_free_tier = true
    db_workload = var.workload_type
    admin_password = var.admin_password
}

