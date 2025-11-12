# Test app deployment

module "salesforcetest2_spa_app" {
  source        = "./modules/okta-app-spa-oidc"
  label         = "Salesforce test 2 app "
  redirect_uris = ["https://test.ft.com/callback"]
  group_names   = ["Iamconnect_Salesforcenew_Users"]
}
