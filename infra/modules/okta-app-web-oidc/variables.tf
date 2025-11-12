variable "label" {
  type = string
}

variable "redirect_uris" {
  type = list(string)
}

variable "post_logout_redirect_uris" {
  type    = list(string)
  default = []
}

variable "grant_types" {
  type    = list(string)
  default = ["authorization_code", "refresh_token"]
}

variable "response_types" {
  type    = list(string)
  default = ["code"]
}

variable "consent_method" {
  type    = string
  default = "TRUSTED" # or "REQUIRED"
}

variable "group_names" {
  type    = list(string)
  default = []
}

variable "group_ids" {
  type    = list(string)
  default = []
}
