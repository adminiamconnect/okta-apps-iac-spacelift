terraform {
  required_version = ">= 1.5.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "= 6.2.1"   # <- known stable; avoids 6.4.x crashes
    }
  }
}
