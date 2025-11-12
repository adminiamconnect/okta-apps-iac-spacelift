variable "label" {
  type = string
}

variable "sso_url" {
  type = string
}

variable "recipient" {
  type = string
}

variable "destination" {
  type = string
}

variable "audience" {
  type = string
}

variable "subject_name_id_format" {
  type    = string
  default = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
}

variable "signature_algorithm" {
  type    = string
  default = "RSA_SHA256"
}

variable "digest_algorithm" {
  type    = string
  default = "SHA256"
}

variable "group_names" {
  type    = list(string)
  default = []
}

variable "group_ids" {
  type    = list(string)
  default = []
}
