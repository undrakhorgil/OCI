variable "prod_key_display_name" {
  description = "Display name for the production key"
  type        = string
}
variable "dss_key_display_name" {
  description = "Display name for the DSS key"
  type        = string
}
variable "prod_key_algorithm" {
  description = "Algorithm for the production key"
  type        = string
  default     = "AES"
}
variable "prod_key_length" {
  description = "Length for the production key"
  type        = number
  default     = 32
}
variable "dss_key_algorithm" {
  description = "Algorithm for the DSS key"
  type        = string
  default     = "AES"
}
variable "dss_key_length" {
  description = "Length for the DSS key"    
  type        = number
  default     = 32
}
variable "prod_key_protection_mode" {
  description = "Protection mode for the production key"
  type        = string
  default     = "SOFTWARE"
}
variable "dss_key_protection_mode" {
  description = "Protection mode for the DSS key"
  type        = string
  default     = "SOFTWARE"
}
    