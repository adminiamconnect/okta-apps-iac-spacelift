module "groups" {
  source      = "../okta-groups"
  group_names = var.group_names
}

resource "okta_app_saml" "this" {
  label             = var.label
  preconfigured_app = var.preconfigured_app
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
