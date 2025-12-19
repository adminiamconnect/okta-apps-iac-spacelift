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

######## WEB SAML ########
module "salesforce_app" {
  source      = "./modules/okta-app-web-saml"
  label       = "Salesforce test"
  sso_url     = "https://legacy.ft.com/saml/acs"
  recipient   = "https://legacy.ft.com/saml/acs"
  destination = "https://legacy.ft.com/saml/acs"
  audience    = "https://legacy.ft.com/saml/metadata"
  group_names = ["Salesforce Users"]
}

######## WEB SAML ########
module "lucid_app" {
  source      = "./modules/okta-app-web-saml"
  label       = "Lucid test"
  sso_url     = "https://lucid.test.com/saml/acs"
  recipient   = "https://lucid.test.com/saml/acs"
  destination = "https://lucid.test.com/saml/acs"
  audience    = "https://lucid.test.com/saml/metadata"
  group_names = ["Lucid Users"]
}

######## WEB SAML ########
module "iamconnect_app" {
  source      = "./modules/okta-app-web-saml"
  label       = "IAM Connect"
  sso_url     = "https://iamconnect.co.uk/saml/acs"
  recipient   = "https://iamconnect.co.uk/saml/acs"
  destination = "https://iamconnect.co.uk/saml/acs"
  audience    = "https://iamconnect.co.uk/saml/metadata"
  group_names = ["IAM Connect Users"]
}

######## WEB SAML PRECONFIG ########
module "AWS" {
  source = "./modules/okta-app-web-saml-preconfig"

  label             = "AWS IAM Identity Center"
  preconfigured_app = "amazon_aws_sso"

  app_settings_json = jsonencode({
    acsURL   = "https://eu-west-1.signin.aws.amazon.com/platform/saml/acs/4455422d84a27c9f-9f18-41fa-81b4-769660979b1e"
    entityID = "https://eu-west-1.signin.aws.amazon.com/platform/saml/d-936792b6ea"
  })

  group_names = ["AWS Admins"]
}
######## WEB SAML ########
module "Entra_enterprise_app" {
  source      = "./modules/okta-app-web-saml"
  label       = "Entra ID"
  sso_url     = "https://login.microsoftonline.com/c9fe51cf-f49a-4e60-b07a-ccd553d45f5c/saml2"
  recipient   = "https://login.microsoftonline.com/c9fe51cf-f49a-4e60-b07a-ccd553d45f5c/saml2"
  destination = "https://login.microsoftonline.com/c9fe51cf-f49a-4e60-b07a-ccd553d45f5c/saml2"
  audience    = "https://login.microsoftonline.com/c9fe51cf-f49a-4e60-b07a-ccd553d45f5c/federationmetadata/2007-06/federationmetadata.xml?appid=ffa3aaf5-5755-450a-a7ad-9c48dd12f5a3"
  group_names = ["Entra ID Users"]
}
