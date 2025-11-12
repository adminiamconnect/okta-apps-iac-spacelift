# iamconnect
Michael Projects for SSO Pipelines to Okta and other providers

# okta-apps-iac-spacelift

Infrastructure-as-Code for managing **Okta applications and groups** using **Terraform (OpenTofu)** and deployed through **Spacelift**.  
This repository provides a modular, automated, and secure way to define and manage your Okta configuration across multiple environments (dev, staging, prod).

---

## 🚀 Overview

This repo enables:
- Declarative provisioning of Okta **OIDC** and **SAML** applications.
- Centralized management of **Okta groups** and app-group assignments.
- Seamless CI/CD integration via **Spacelift**.
- Environment separation (dev / staging / prod).
- Auditable changes via Git-based workflows and PR reviews.

Supported app types:
- ✅ `web_oidc`
- ✅ `spa_oidc`
- ✅ `native_oidc`
- ✅ `web_saml`
- ✅ `web_saml_preconfig`
- ✅ `okta_groups` (standalone or per app)

---

## 🏗 Repository Structure

.
├─ infra/ # Terraform / OpenTofu entry point (Spacelift project root)
│ ├─ main.tf # Example app deployments
│ ├─ providers.tf # Okta provider config
│ ├─ versions.tf # Provider + TF version lock
│ ├─ modules/
│ │ ├─ okta-app-web-oidc/
│ │ ├─ okta-app-spa-oidc/
│ │ ├─ okta-app-native-oidc/
│ │ ├─ okta-app-web-saml/
│ │ ├─ okta-app-web-saml-preconfig/
│ │ └─ okta-groups/
│ └─ env/
│ ├─ dev/
│ ├─ staging/
│ └─ prod/
├─ docs/
│ └─ okta-spacelift-setup.md # Detailed technical setup guide
└─ spacelift.yaml # Optional - define stacks as code

yaml
Copy code

---

## ⚙️ Provider Configuration

**File:** `infra/providers.tf`

```hcl
variable "okta_org_name" {}                    # e.g. dev-12345678
variable "okta_base_url" { default = "okta.com" } # okta.com | okta-emea.com | oktapreview.com
variable "okta_api_token" { sensitive = true }

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}
🔐 Spacelift Integration
Connect GitHub repo → Spacelift.

Create a Stack for each environment (e.g. okta-dev, okta-prod).

Set project root = infra (or infra/env/dev, etc).

Add environment variables under Stack → Settings → Environment:

Variable	Example	Type
TF_VAR_okta_org_name	dev-12345678	Plain
TF_VAR_okta_base_url	okta-emea.com	Plain
TF_VAR_okta_api_token	00aBcdEfGhIjKlm...	Secret

🔸 Do not include the SSWS prefix in your API token.
🔸 Do not use a custom Okta vanity domain.

🧱 Example: Web + SPA OIDC apps
h
Copy code
module "app_web_oidc" {
  source        = "./modules/okta-app-web-oidc"
  label         = "ft-portal"
  redirect_uris = ["https://portal.ft.com/callback"]
  post_logout_redirect_uris = ["https://portal.ft.com"]
  group_names   = ["FT_PORTAL_USERS"]
}

module "app_spa_oidc" {
  source        = "./modules/okta-app-spa-oidc"
  label         = "ft-dashboard"
  redirect_uris = ["https://dashboard.ft.com/callback"]
  group_names   = ["FT_DASHBOARD_USERS"]
}
🧩 Modular Approach
Each module encapsulates app creation logic:

Module	Purpose
okta-app-web-oidc	For backend web apps using Authorization Code flow
okta-app-spa-oidc	For front-end single-page apps using Implicit + PKCE
okta-app-native-oidc	For mobile/desktop native clients
okta-app-web-saml	Custom SAML app integration
okta-app-web-saml-preconfig	Okta Catalog apps (Box, Zendesk, etc.)
okta-groups	Create or fetch Okta groups

All app modules accept:

group_names → Creates and assigns new groups.

group_ids → Assigns existing groups by ID.

🧠 Spacelift Workflow
PR opened: Spacelift runs Plan → preview changes.
PR merged: Spacelift runs Apply → deploys to Okta.
Manual approvals (recommended) can be enforced via Spacelift policies.

Typical Stack Lifecycle
Push change → triggers Plan

Review Plan → approve → merge

Stack auto-applies → Okta app created or updated

Logs and state stored in Spacelift

🧰 Local Testing (optional)
bash
Copy code
cd infra
tofu init
tofu plan -var 'okta_org_name=dev-12345678' \
          -var 'okta_base_url=okta-emea.com' \
          -var 'okta_api_token=00aBcdEf...'
🧾 Troubleshooting
Error	Fix
401 Unauthorized	Check token, org name, base URL, no SSWS prefix
project root Infra does not exist	Ensure stack Project Root matches folder name exactly
error creating app	Validate redirect URIs and app type
rate limit exceeded	Split batch deployments across stacks

🛡 Security Best Practices
Store tokens only in Spacelift Secrets.

Use separate API tokens for dev and prod.

Enforce manual approval on production applies.

Enable version pinning (= 6.1.0).

Use Spacelift policies to prevent destructive actions.

👥 Contributors
Role	Name / Team
IAM Engineering	Michael Corrodus
Platform Engineering	TBD
Security Operations	TBD

📚 References
Okta Terraform Provider Docs

Spacelift Documentation

OpenTofu CLI Reference



## Stability tweaks for Okta provider in CI

This repo pins the Okta Terraform provider to the `~> 6.4` series and throttles
API usage via `max_api_capacity` (default 50%).

When running in Spacelift or CI, set Terraform parallelism conservatively to avoid
rate limiting:

```
TF_CLI_ARGS_plan  = -parallelism=2
TF_CLI_ARGS_apply = -parallelism=2
```

You can tune `var.okta_max_api_capacity` and the above parallelism values upward after
a few stable runs.
