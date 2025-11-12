variable "label" { type = string }
variable "preconfigured_app" { type = string } # e.g., "boxnet", "zendesk"
variable "group_names" { type = list(string) default = [] }
variable "group_ids" { type = list(string) default = [] }
