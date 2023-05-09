locals {
  groups = { for group in var.acc_level_groups : group.name => group if group.name != null }

  users = flatten([for group in var.acc_level_groups : [for user in coalesce(group.users, []) : {
    name = group.name
    user = user
    } if group.users != null
  ]])
  users_as_map = { for user_obj in local.users : "${user_obj.name}:${user_obj.user}" => user_obj }

  sp = flatten([for group in var.acc_level_groups : [for sp in coalesce(group.service_principal, []) : {
    name = group.name
    sp   = sp
    } if group.service_principal != null
  ]])
  sp_as_map = { for sp_obj in local.sp : "${sp_obj.name}:${sp_obj.sp}" => sp_obj }
}

data "databricks_user" "user" {
  for_each = local.users_as_map

  user_name = each.value.user
}

data "databricks_service_principal" "sp" {
  for_each = local.sp_as_map

  application_id = each.value.sp
}

data "databricks_group" "existing" {
  for_each = { for group in var.workspace_group_assignment : group.principal_id => group }

  display_name = each.key
}

resource "databricks_group" "this" {
  for_each = local.groups

  display_name = each.value.name
  lifecycle { ignore_changes = [external_id, allow_cluster_create, allow_instance_pool_create, databricks_sql_access, workspace_access] }
}

# Assignment Databricks users as members of the group
resource "databricks_group_member" "users" {
  for_each = local.users_as_map

  group_id  = databricks_group.this[each.value.name].id
  member_id = data.databricks_user.user[each.key].id

}

# Assignment Databricks service principals as members of the group
resource "databricks_group_member" "sp" {
  for_each = local.sp_as_map

  group_id  = databricks_group.this[each.value.name].id
  member_id = data.databricks_service_principal.sp[each.key].id
}

# Adding account-level group to a workspace in account context
resource "databricks_mws_permission_assignment" "this" {
  for_each = { for group in var.workspace_group_assignment : group.principal_id => group }

  workspace_id = var.workspace
  principal_id = data.databricks_group.existing[each.key].id
  permissions  = each.value.permissions
}
