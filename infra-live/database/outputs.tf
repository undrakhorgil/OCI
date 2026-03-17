output "db_prod_id" {
    value = module.my_db_prod.db_id
    sensitive = true
}
output "db_prod_name" {
    value = module.my_db_prod.db_name
}
output "db_prod_display_name" {
    value = module.my_db_prod.db_display_name
}
output "db_dss_id" {
    value = module.my_db_dss.db_id
    sensitive = true
}
output "db_dss_name" {
    value = module.my_db_dss.db_name
}
output "db_dss_display_name" {
    value = module.my_db_dss.db_display_name
}