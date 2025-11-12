variable "okta_org_name" {}
variable "okta_base_url" {
  description = "okta.com | okta-emea.com | oktapreview.com"
  default     = "okta.com"
}
variable "okta_api_token" {
  sensitive = true
}

variable "okta_max_api_capacity" {
  description = "Throttle Okta provider requests as a percentage of org capacity (10-100)."
  type        = number
  default     = 50
}

provider "okta" {
  max_api_capacity = var.okta_max_api_capacity
  org_name         = var.okta_org_name
  base_url         = var.okta_base_url
  api_token        = var.okta_api_token

}
