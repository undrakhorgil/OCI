variable "compartment_ocid" { sensitive = true } 
variable "display_name" {}
variable "vault_type" {
  description = "The type of vault to create"
  default     = "SOFTWARE"
}