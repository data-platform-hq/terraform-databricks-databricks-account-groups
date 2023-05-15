locals {
  users = flatten([for group in var.groups : [for user in coalesce(group.users, []) : {
    name = group.name
    user = user
    } if group.users != null
  ]])
  users_as_map = { for user_object in local.users : "${user_object.name}:${user_object.user}" => user_object }

  service_principals = flatten([for group in var.groups : [for sp in coalesce(group.service_principal, []) : {
    name              = group.name
    service_principal = sp
    } if group.service_principal != null
  ]])
  service_principals_as_map = { for sp_object in local.service_principals : "${sp_object.name}:${sp_object.service_principal}" => sp_object }
}

data "databricks_user" "this" {
  for_each = local.users_as_map

  user_name = each.value.user
}

data "databricks_service_principal" "this" {
  for_each = local.service_principals_as_map

  application_id = each.value.service_principal
}

data "databricks_group" "existing" {
  for_each = { for group in var.workspace_group_assignment : group.principal_id => group }

  display_name = each.key
}

resource "databricks_group" "this" {
  for_each = toset(var.groups[*].name)

  display_name = each.key
  lifecycle { ignore_changes = [external_id, allow_cluster_create, allow_instance_pool_create, databricks_sql_access, workspace_access] }
}

# Assignment Databricks users as members of the group
resource "databricks_group_member" "user" {
  for_each = local.users_as_map

  group_id  = databricks_group.this[each.value.name].id
  member_id = data.databricks_user.this[each.key].id

}

# Assignment Databricks service principals as members of the group
resource "databricks_group_member" "service_principal" {
  for_each = local.service_principals_as_map

  group_id  = databricks_group.this[each.value.name].id
  member_id = data.databricks_service_principal.this[each.key].id
}

# Adding account level group to a workspace in account context
resource "databricks_mws_permission_assignment" "this" {
  for_each = { for group in var.workspace_group_assignment : group.principal_id => group }

  workspace_id = var.workspace
  principal_id = data.databricks_group.existing[each.key].id
  permissions  = each.value.permissions
}
