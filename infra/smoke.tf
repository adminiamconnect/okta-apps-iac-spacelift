# Smoke test: create a simple Okta group directly (no module)
resource "okta_group" "iac_smoke_test" {
  name        = "IAC_SMOKE_TEST"
  description = "Created by Spacelift to verify pipeline"
}
