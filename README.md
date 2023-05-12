# Databricks Account Groups Terraform module
Terraform module for creation Databricks Account Groups and assignment them to the Databricks Premium Workspace

## Usage


| Name                                                                         | Version  |
| ---------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.9.2 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.9.2   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                         | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [databricks_user.user"](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_global_config)                               | data     |
| [databricks_service_principal.sp](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/service_principal)                  | data     |
| [databricks_group.existing](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group)                                    | data     |
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group)                                           | resource |
| [databricks_group_member.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                            | resource |
| [databricks_group_member.sp](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                               | resource |
| [databricks_mws_permission_assignment" "this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |

## Inputs

| Name                                                                                                                 | Description                                                                                               | Type                                                                                                                                                          | Default | Required |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_acc_level_groups"></a> [acc\_level\_groups](#input\_acc\_level\_groups)                               | The ID of the Databricks workspace to which account groups should be assigned                             | <pre>list(object({<br>  name              = string<br>  users             = optional(set(string))<br>  service_principal = optional(set(string))<br>}))</pre> | []      |    no    |
| <a name="input_workspace"></a> [workspace](#input\_workspace)                                                        | The ID of the Databricks workspace to which account groups should be assigned                             | `string`                                                                                                                                                      | "null"  |    no    |
| <a name="input_workspace_group_assignment"></a> [workspace\_group\_assignment](#input\_workspace\_group\_assignment) | List of objects with group name and list of workspace permissions (USER or ADMIN) to assign to this group | <pre>list(object({<br>  principal_id = optional(string),<br>  permissions  = optional(list(string))<br>}))</pre>                                              | []      |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-databricks-account-groups/blob/main/LICENSE)
