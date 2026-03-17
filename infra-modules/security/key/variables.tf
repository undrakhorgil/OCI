variable "compartment_ocid" { sensitive = true } 
variable "display_name" {}
variable "management_endpoint" { sensitive = true }
variable "algorithm" {
    default = "AES"
}
variable "length" {
    default = 32
}
variable "protection_mode" {
    default = "SOFTWARE"
}