locals {
  # Creates maps of objects where key is in form like "user:<group_name>:<user_name>" and value is objects of two parameters,
  # first element is a group name and second is user name
  users_map = {
    for object in flatten([
      for group in var.groups : [
        for pair in setproduct([group.name], group.users) : {
          name = pair[0], user = pair[1]
      }] if alltrue([group.name != null, group.users != null])
    ]) : "user:${object.name}:${object.user}" => object
  }

  # Creates maps of objects where key is in form like "sp:<group_name>:<user_name>" and value is object of two parameters,
  # first element is a group name and second is service principal name
  service_principals_map = {
    for object in flatten([
      for group in var.groups : [
        for pair in setproduct([group.name], group.service_principals) : {
          name = pair[0], service_principal = pair[1]
      }] if alltrue([group.name != null, group.service_principals != null])
    ]) : "sp:${object.name}:${object.service_principal}" => object
  }
}

# Reference to already existing User in Databricks Account
data "databricks_user" "this" {
  for_each = local.users_map

  user_name = each.value.user
}

# Reference to already existing Service Principal in Databricks Account
data "databricks_service_principal" "this" {
  for_each = local.service_principals_map

  application_id = each.value.service_principal
}

# Creates group in Databricks Account
resource "databricks_group" "this" {
  for_each = toset(compact(var.groups[*].name))

  display_name = each.key
  lifecycle { ignore_changes = [external_id, allow_cluster_create, allow_instance_pool_create, databricks_sql_access, workspace_access] }
}

# Adds Users and Service Principals to associated Databricks Account group
resource "databricks_group_member" "this" {
  for_each = merge(local.users_map, local.service_principals_map)

  group_id  = databricks_group.this[each.value.name].id
  member_id = startswith(each.key, "user") ? data.databricks_user.this[each.key].id : data.databricks_service_principal.this[each.key].id
}

# References already existing or newly created groups in Databricks Account.
data "databricks_group" "this" {
  for_each = toset(compact(var.workspace_group_assignment[*].group_name))

  display_name = each.value
  depends_on   = [databricks_group.this]
}

# Assigning Databricks Account group to Databricks Workspace
resource "databricks_mws_permission_assignment" "this" {
  for_each = {
    for group in var.workspace_group_assignment : group.group_name => group
    if group.group_name != null
  }

  workspace_id = var.workspace_id
  principal_id = data.databricks_group.this[each.key].id
  permissions  = each.value.permissions

  lifecycle {
    ignore_changes = [principal_id]
  }
}
