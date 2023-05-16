# Databricks Account Groups Terraform module
Terraform module for creation Databricks Account Groups and assignment them
to the Databricks Premium Workspace

## Usage
Current module allows you to create groups in the Databricks account, add users 
and service principals as a members of those groups. This module also allows to
add account groups to the Databricks Workspace.
In order to operate at the account level the following required_providers block
should be added:

```hcl
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.14.2"
    }
  }
}

provider "databricks" {
  alias = "manager"

  host       = "https://accounts.azuredatabricks.net"
  account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
}
```
Here is an example of using this module to create groups and how to pass parameters
to assign these groups to a Workspace:
```hcl

module "databricks_account_groups" {
  providers = {
    databricks = databricks.manager
  }

  # Databricks account groups creation
  groups = groups = [{
    name              = "test_group1"
    users             = ["user_name1@email.com", "user_name2@email.com"]
    service_principal = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
    }, {
    name  = "test_group2"
    users = ["user_name1@email.com", "user_name3@email.com"]
  }]

  # Databricks account groups assignment
  workspace                  = "databricks_workspace_id"
  workspace_group_assignment = [{
    principal_id = "test_group1"
    permissions  = ["ADMIN"]
    }, {
    principal_id = "test_group2",
    permissions  = ["USER"]
  }]
}
```

| Name                                                                         | Version   |
| ---------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0.0  |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.14.2 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.14.2  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                       | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [databricks_user.this"](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_global_config)                             | data     |
| [databricks_service_principal.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/service_principal)              | data     |
| [databricks_group.existing](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group)                                  | data     |
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group)                                         | resource |
| [databricks_group_member.users](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                          | resource |
| [databricks_group_member.service_principal](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)              | resource |
| [databricks_mws_permission_assignment.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |

## Inputs

| Name                                                                                                                 | Description                                                                                               | Type                                                                                                                                                          | Default | Required |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_groups"></a> [groups](#input\_groups)                                                                 | The ID of the Databricks workspace to which account groups should be assigned                             | <pre>list(object({<br>  name              = string<br>  users             = optional(set(string))<br>  service_principal = optional(set(string))<br>}))</pre> | []      |    no    |
| <a name="input_workspace"></a> [workspace](#input\_workspace)                                                        | The ID of the Databricks workspace to which account groups should be assigned                             | `string`                                                                                                                                                      | "null"  |    no    |
| <a name="input_workspace_group_assignment"></a> [workspace\_group\_assignment](#input\_workspace\_group\_assignment) | List of objects with group name and list of workspace permissions (USER or ADMIN) to assign to this group | <pre>list(object({<br>  principal_id = optional(string),<br>  permissions  = optional(list(string))<br>}))</pre>                                              | []      |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-databricks-account-groups/blob/main/LICENSE)
