variable "prod_vault_display_name" {
  description = "Display name for the production vault"
  type        = string
}
variable "dss_vault_display_name" {
  description = "Display name for the DSS vault"
  type        = string
}
variable "prod_vault_type" {
  description = "Type for the production vault"
  type        = string
  default     = "SOFTWARE"
}
variable "dss_vault_type" {
  description = "Type for the DSS vault"
  type        = string
  default     = "SOFTWARE"
}
    