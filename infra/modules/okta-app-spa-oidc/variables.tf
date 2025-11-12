variable "label" { type = string }
variable "redirect_uris" { type = list(string) }
variable "group_names" { type = list(string) default = [] }
variable "group_ids" { type = list(string) default = [] }
