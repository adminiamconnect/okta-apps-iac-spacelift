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

variable "subject_name_id_template" {
  type = string
  # Default to the Okta template that uses the user's email as the NameID.
  # Use "$${...}" to keep the interpolation as a literal template rather than
  # attempting to evaluate variables in a default value (Terraform disallows
  # referencing other variables in defaults). This results in the literal
  # string "${user.email}" being used by the provider.
  default = "$${user.email}"
}

variable "authn_context_class_ref" {
  type    = string
  default = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
}
