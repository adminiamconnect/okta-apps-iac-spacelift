terraform {
  required_version = ">= 1.5.0"
  rrequired_providers {
    okta = {
      source = "okta/okta"
      version = "3.11.1"
    }
  }
}
