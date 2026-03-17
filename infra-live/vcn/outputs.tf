output "vcn_prod_id" {
    value = module.my_vcn_prod.vcn_id
}
output "vcn_prod_cidr_block" {
    value = module.my_vcn_prod.vcn_cidr_block
}
output "vcn_prod_display_name" {
    value = module.my_vcn_prod.vcn_display_name     
}
output "vcn_prod_dns_label" {
    value = module.my_vcn_prod.vcn_dns_label
}
output "vcn_dss_id" {
    value = module.my_vcn_dss.vcn_id
}
output "vcn_dss_cidr_block" {
    value = module.my_vcn_dss.vcn_cidr_block
}
output "vcn_dss_display_name" {
    value = module.my_vcn_dss.vcn_display_name
}
output "vcn_dss_dns_label" {
    value = module.my_vcn_dss.vcn_dns_label
}
output "vcn_prod_public_subnet_id" {
    value = module.my_vcn_prod.public_subnet_id
}
output "vcn_prod_private_subnet_id" {
    value = module.my_vcn_prod.private_subnet_id
}
output "vcn_prod_internet_gateway_id" {
    value = module.my_vcn_prod.internet_gateway_id
}
output "vcn_dss_public_subnet_id" {
    value = module.my_vcn_dss.public_subnet_id
}
output "vcn_dss_private_subnet_id" {
    value = module.my_vcn_dss.private_subnet_id
}
output "vcn_dss_internet_gateway_id" {
    value = module.my_vcn_dss.internet_gateway_id
}
