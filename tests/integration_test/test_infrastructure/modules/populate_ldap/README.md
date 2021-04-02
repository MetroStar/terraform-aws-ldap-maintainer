# Populate LDAP Lambda

Lambda function used to populate a target SimpleAD deployment with 1000+ test users for use with the ldap-maintenance project.

Names were generated using the uinames.com api with the following command: `curl https://uinames.com/api/?region=United%20States\&amount=500`

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_base\_dn | Distinguished name of the domain | `string` | n/a | yes |
| ldaps\_url | LDAPS URL for the target domain | `string` | n/a | yes |
| python\_ldap\_layer\_arn | ARN of the python-ldap layer | `string` | n/a | yes |
| svc\_user\_dn | Distinguished name of the user account used to manage simpleAD | `string` | n/a | yes |
| svc\_user\_pwd | SSM parameter key that contains the service account password | `string` | n/a | yes |
| vpc\_id | VPC ID of the VPC hosting your Simple AD instance | `string` | n/a | yes |
| filter\_prefixes | List of user name prefixes to filter out of the user search results | `list(string)` | `[]` | no |
| log\_level | Log level of the lambda output, one of: Debug, Info, Warning, Error, or Critical | `string` | `"Info"` | no |
| project\_name | Name of the project | `string` | `"ldap-maintainer"` | no |
| tags | Map of tags | `map(string)` | `{}` | no |
| test\_users | List of test users in Firstname Lastname format | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | The ARN of the Lambda function |
| function\_invoke\_arn | The Invoke ARN of the Lambda function |
| function\_name | The name of the Lambda function |
| function\_qualified\_arn | The qualified ARN of the Lambda function |
| role\_arn | The ARN of the IAM role created for the Lambda function |
| role\_name | The name of the IAM role created for the Lambda function |

<!-- END TFDOCS -->
