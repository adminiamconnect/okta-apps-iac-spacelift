variable "group_names" {
  description = "Create or fetch these groups by name"
  type        = list(string)
  default     = []
}

variable "descriptions" {
  description = "Optional description per group name (same order as group_names)"
  type        = list(string)
  default     = []
}
