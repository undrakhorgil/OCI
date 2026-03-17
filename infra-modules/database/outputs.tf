output "db_id" {
    value = oci_database_autonomous_database.free_db.id 
    sensitive = true
}

output "db_name" {
    value = oci_database_autonomous_database.free_db.db_name
}

output "db_display_name" {
    value = oci_database_autonomous_database.free_db.display_name
}

output "db_workload" {
    value = oci_database_autonomous_database.free_db.db_workload
}   