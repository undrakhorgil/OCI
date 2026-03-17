output "vcn_id" {
    value = oci_core_virtual_network.vcn.id
}   
output "vcn_cidr_block" {
    value = oci_core_virtual_network.vcn.cidr_block
}
output "vcn_display_name" {
    value = oci_core_virtual_network.vcn.display_name
}
output "vcn_dns_label" {
    value = oci_core_virtual_network.vcn.dns_label
}
output "public_subnet_id" {
    value = oci_core_subnet.public_subnet.id
}
output "private_subnet_id" {
    value = oci_core_subnet.private_subnet.id
}
output "internet_gateway_id" {
    value = oci_core_internet_gateway.internet_gateway.id
}