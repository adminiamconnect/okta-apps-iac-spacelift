module "groups" {
  source      = "../okta-groups"
  group_names = var.group_names
}

resource "okta_app_saml" "saml" {
  label = var.label

  sso_url     = var.sso_url
  recipient   = var.recipient
  destination = var.destination
  audience    = var.audience

  # was: name_id_format = var.name_id_format
  subject_name_id_format   = var.subject_name_id_format
  subject_name_id_template = var.subject_name_id_template

  signature_algorithm     = var.signature_algorithm
  digest_algorithm        = var.digest_algorithm
  authn_context_class_ref = var.authn_context_class_ref
  # Ensure SAML assertions and responses are signed for stronger security.
  response_signed   = true
  assertion_signed  = true
  honor_force_authn = true
}

locals {
  all_group_ids = concat(var.group_ids, [for g in module.groups.groups : g.id])
}

resource "okta_app_group_assignments" "assign" {
  app_id = okta_app_saml.saml.id
  dynamic "group" {
    for_each = toset(local.all_group_ids)
    content { id = group.value }
  }
}

output "app_id" { value = okta_app_saml.saml.id }
output "assigned_group_ids" { value = [for g in okta_app_group_assignments.assign.group : g.id] }
