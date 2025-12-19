#######################################################
# Example: Okta Applications and Groups (single env)
#######################################################

# Shared groups
module "shared_groups" {
  source      = "./modules/okta-groups"
  group_names = ["FT_SHARED_USERS"]
}

######## WEB OIDC ########
module "IAM_Connect" {
  source                    = "./modules/okta-app-web-oidc"
  label                     = "IAM Connect"
  redirect_uris             = ["https://iamconnect.co.uk"]
  post_logout_redirect_uris = ["https://iamconnect.co.uk"]
  group_ids                 = [for g in module.shared_groups.groups : g.id]
}

######## NATIVE OIDC ########
module "IAM_Connect2" {
  source        = "./modules/okta-app-native-oidc"
  label         = "IAM Connect 2"
  redirect_uris = ["https://iamconnect.co.uk"]
  group_names   = ["IAM Connect 2 Users"]
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
