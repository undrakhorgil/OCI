variable "cidr_block" {}
variable "display_name" {}
variable "dns_label" {}
variable "public_subnet_cidr_block" {}
variable "public_subnet_display_name" {}
variable "private_subnet_cidr_block" {}
variable "private_subnet_display_name" {}
variable "internet_gateway_display_name" {}
variable "compartment_ocid" { sensitive = true } 
