variable "acc_level_groups" {
  type = list(object({
    name              = string
    users             = optional(set(string))
    service_principal = optional(set(string))
  }))
  description = "List of group names and sets of users and/or service principals assigned to these groups"
  default     = []
}

variable "workspace" {
  type        = string
  description = "The ID of the Databricks workspace to which account groups should be assigned"
  default     = null
}

variable "workspace_group_assignment" {
  type = list(object({
    principal_id = optional(string),
    permissions  = optional(list(string))
  }))
  description = "List of objects with group name and list of workspace permissions (USER or ADMIN) to assign to this group"
  default     = []
}
