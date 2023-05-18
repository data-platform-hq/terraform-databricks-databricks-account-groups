# Databricks Account Groups Terraform module
Terraform module for creation Databricks Account Groups and assignments 
to the Databricks Premium Workspace

## Usage
Current module allows you to create groups in the Databricks Account, add users and service principals as a members of those groups. 
This module also provides an ability to assign just created or already existing Account Groups to the Databricks Workspace.

In order to operate at the Account level the following required_providers block should be configured first:

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
  
  # Databricks Account UUID
  account_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
}
```

Here is an example of using this module to create Account Groups and then assign them to the Workspace:
```hcl
data "azurerm_databricks_workspace" "example" {
  name                = "example-workspace"
  resource_group_name = "example-rg"
}

module "databricks_account_groups" {
  providers = {
    databricks = databricks.manager
  }

  # Databricks Account groups creation
  groups = [{
    name               = "test_group1"
    users              = ["user_name1@email.com", "user_name2@email.com"]
    service_principals = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
    }, {
    name  = "test_group2"
    users = ["user_name1@email.com", "user_name3@email.com"]
  }]

  # Databricks Account groups assignment to certain Workspace
  workspace_id = data.azurerm_databricks_workspace.example.id
  
  workspace_group_assignment = [{
    group_name  = "test_group1"
    permissions = ["ADMIN"]
    }, {
    group_name  = "test_group2",
    permissions = ["USER"]
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
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group)                                         | resource |
| [databricks_group_member.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/group_member)                           | resource |
| [databricks_group.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/group)                                      | data     |
| [databricks_mws_permission_assignment.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment) | resource |

## Inputs

| Name                                                                                                                 | Description                                                                                               | Type                                                                                                                                                          | Default | Required |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_groups"></a> [groups](#input\_groups)                                                                 | List of objects with these parameters -  group names to create, sets of users and/or service principals assigned to these groups                             | <pre>list(object({<br>  name               = string<br>  users              = optional(set(string))<br>  service_principals = optional(set(string))<br>}))</pre> | []      |    no    |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id)                                             | The ID of the Databricks Workspace to which Account groups should be assigned                             | `string`                                                                                                                                                      | "null"  |    no    |
| <a name="input_workspace_group_assignment"></a> [workspace\_group\_assignment](#input\_workspace\_group\_assignment) | List of objects with group name and list of workspace permissions (USER or ADMIN) to assign to this group | <pre>list(object({<br>  group_name  = optional(string),<br>  permissions = optional(list(string))<br>}))</pre>                                              | []      |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-databricks-account-groups/blob/main/LICENSE)
