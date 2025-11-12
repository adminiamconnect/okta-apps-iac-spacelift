module "groups" {
  source      = "../okta-groups"
  group_names = var.group_names
}

resource "okta_app_oauth" "this" {
  label          = var.label
  type           = "native"
  grant_types    = ["authorization_code", "refresh_token"]
  response_types = ["code"]
  redirect_uris  = var.redirect_uris
  post_logout_redirect_uris = var.post_logout_redirect_uris
}

locals {
  all_group_ids = concat(var.group_ids, [for g in module.groups.groups : g.id])
}

resource "okta_app_group_assignments" "assign" {
  app_id = okta_app_oauth.this.id
  dynamic "group" {
    for_each = toset(local.all_group_ids)
    content { id = group.value }
  }
}

output "app_id" {
  value = okta_app_oauth.this.id
}

output "client_id" {
  value = okta_app_oauth.this.client_id
}

output "assigned_group_ids" {
  value = [for g in okta_app_group_assignments.assign.group : g.id]
}

