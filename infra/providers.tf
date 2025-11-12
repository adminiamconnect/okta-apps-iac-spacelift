variable "okta_org_name" {}
variable "okta_base_url" {
  description = "okta.com | okta-emea.com | oktapreview.com"
  default     = "okta.com"
}
variable "okta_api_token" {
  sensitive = true
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}
