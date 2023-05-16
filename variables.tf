variable "groups" {
  type = list(object({
    name               = optional(string)
    users              = optional(set(string))
    service_principals = optional(set(string))
  }))
  description = "List of objects with these parameters -  group names to create, sets of users and/or service principals assigned to these groups"
  default     = []
}

variable "workspace_id" {
  type        = string
  description = "The ID of the Databricks Workspace where Databricks Account group would be assigned"
  default     = null
}

variable "workspace_group_assignment" {
  type = list(object({
    group_name  = optional(string),
    permissions = optional(list(string))
  }))
  description = "List of objects with group name and list of workspace permissions (USER or ADMIN) to assign to this group"
  default     = []

  validation {
    condition = length(var.workspace_group_assignment) != 0 ? alltrue([
      for item in toset(flatten(var.workspace_group_assignment[*].permissions)) : contains(["USER", "ADMIN"], item)
      if item != null
    ]) : true
    error_message = "Please provide either 'USER' or 'ADMIN' permission level for Account group on Workspace"
  }
}
