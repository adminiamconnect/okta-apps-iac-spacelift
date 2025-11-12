#######################################################
# Example: Okta Applications and Groups (single env)
#######################################################

# Shared groups
module "shared_groups" {
  source      = "./modules/okta-groups"
  group_names = ["FT_SHARED_USERS"]
}

######## WEB OIDC ########
module "ft_portal" {
  source                    = "./modules/okta-app-web-oidc"
  label                     = "ft-portal"
  redirect_uris             = ["https://portal.ft.com/callback"]
  post_logout_redirect_uris = ["https://portal.ft.com"]
  group_ids                 = [for g in module.shared_groups.groups : g.id]
}

######## SPA OIDC ########
module "ft_dashboard_spa" {
  source        = "./modules/okta-app-spa-oidc"
  label         = "ft-dashboard"
  redirect_uris = ["https://dashboard.ft.com/callback"]
  group_names   = ["FT_DASHBOARD_USERS"]
}

######## NATIVE OIDC ########
module "ft_mobile" {
  source        = "./modules/okta-app-native-oidc"
  label         = "ft-mobile"
  redirect_uris = ["com.ft.mobile:/callback"]
  group_names   = ["FT_MOBILE_TESTERS"]
}

######## WEB SAML ########
module "legacy_reporter" {
  source      = "./modules/okta-app-web-saml"
  label       = "legacy-reporter"
  sso_url     = "https://legacy.ft.com/saml/acs"
  recipient   = "https://legacy.ft.com/saml/acs"
  destination = "https://legacy.ft.com/saml/acs"
  audience    = "https://legacy.ft.com/saml/metadata"
  group_names = ["FT_REPORTERS"]
}

######## WEB SAML PRECONFIG ########
module "box" {
  source            = "./modules/okta-app-web-saml-preconfig"
  label             = "Box"
  preconfigured_app = "boxnet"
  group_names       = ["FT_BOX_ADMINS"]
}
