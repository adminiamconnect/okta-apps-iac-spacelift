module "groups" {
  source      = "../okta-groups"
  group_names = var.group_names
}

resource "okta_app_saml" "this" {
  label = var.label

  sso_url     = var.sso_url
  recipient   = var.recipient
  destination = var.destination
  audience    = var.audience

  name_id_format      = var.name_id_format
  signature_algorithm = var.signature_algorithm
  digest_algorithm    = var.digest_algorithm
  honor_force_authn   = true
}

locals {
  all_group_ids = concat(var.group_ids, [for g in module.groups.groups : g.id])
}

resource "okta_app_group_assignments" "assign" {
  app_id = okta_app_saml.this.id
  dynamic "group" {
    for_each = toset(local.all_group_ids)
    content { id = group.value }
  }
}

output "app_id" { value = okta_app_saml.this.id }
output "assigned_group_ids" { value = [for g in okta_app_group_assignments.assign.group : g.id] }
