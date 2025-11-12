terraform {
  required_version = ">= 1.5.0"
  required_providers {
    okta = {
      source  = "hashicorp/okta"
      version = "= 6.3.1"     # stable; 6.2.1 also OK if you prefer
    }
  }
}
