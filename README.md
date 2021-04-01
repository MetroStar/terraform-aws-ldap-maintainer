# terraform-aws-ldap-maintainer

A step function to maintain LDAP users via slack.

## Overview

This project deploys a collection of lambda functions, an api gateway endpoint, and a step function implemented with the [callback pattern](https://docs.aws.amazon.com/step-functions/latest/dg/connect-to-resource.html#connect-wait-token) that will automate disabling LDAP users via an interactive slack message.

## Architecture

![State Machine Definition](_docs/state_machine_def_0.0.1.png)

## Submodules

- [API Gateway](/modules/api_gateway): An API endpoint that responds asynchronously to slack events and triggers the Slack Listener lambda function
- [LDAP Query](/modules/ldap_query): Lambda function used to perform actions against a target ldap database
- [Slack Listener](/modules/slack_listener): Lambda function that responds to slack events via an asynchronously executed lambda function
- [Slack Notifier](/modules/slack_notifier): Lambda function that sends status updates to slack and a target step function
- [Slack Bot](/modules/slack_bot): API Gateway endpoint and Lambda function that responds to slash commands from slack

## Setup

1. Retrieve the LDAPS endpoint of your target AD deployment.

    **Note:** This can be accomplished via SimpleAD by creating an ALB that listens via TLS on port 636 and forwards requests to your SimpleAD A record. See the associated [AWS blog post](https://aws.amazon.com/blogs/security/how-to-configure-an-ldaps-endpoint-for-simple-ad/) or the tests of this project for a reference architecture.

2. Within your LDAP directory create a user that will be used by the lambda function. This user will need permissions to query LDAP and disable users.

    **Note:** Refer to the following article to scope this permission to a single user: [Delegate the Enable/Disable Accounts Permission in Active Directory](https://thebackroomtech.com/2009/07/01/howto-delegate-the-enabledisable-accounts-permission-in-active-directory/)

3. Populate an *encrypted* ssm parameter with this new user's password and use the key value as the input for `svc_user_pwd_ssm_key` variable.
4. Generate the lambda layers for this project by running `bin/generate-layers.sh` use the `-r` option to generate the layers via docker or `-c` to create them locally.
5. Register a new slack application at https://api.slack.com and capture the required inputs:
    - the Slack signing secret: Located under the slack application Settings > Basic Information
    - the Bot User OAuth Access Token: Located under the slack application Settings > Install App > Bot User OAuth Access Token
6. Configure your `terraform.tfvars` with the required inputs.
7. Run `terraform init/apply`
8. Using the provided output url, enable slack events for your slack integration
      1. Go to https://api.slack.com
      2. Find your app
      3. Navigate to Features > Event Subscriptions > Enable Events
      4. Enter the api gateway url created in the previous step
      5. Navigate to Features > Slash Commands
      6. Create a new command called `/ldap`
      7. Add the slackbot request url to this command
9. Test the integration from slack by calling `/ldap run` or manually by triggering the LDAP maintenance step function with the following payload: `{"action": "query" }`

## References

- The [AD Schema](https://docs.microsoft.com/en-us/windows/win32/adschema/active-directory-schema)
- Bobbie Couhbor's awesome [blogpost](https://blog.kloud.com.au/2018/01/09/replacing-the-service-desk-with-bots-using-amazon-lex-and-amazon-connect-part-3/) on using python-ldap via lambda
- Rigel Di Scala's blog post [Write a serverless Slack chat bot using AWS](https://chatbotslife.com/write-a-serverless-slack-chat-bot-using-aws-e2d2432c380e)

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
| dynamodb\_table\_arn | ARN of the dynamodb to take actions against | `string` | n/a | yes |
| dynamodb\_table\_name | Name of the dynamodb to take actions against | `string` | n/a | yes |
| ldaps\_url | LDAPS URL of the target domain | `string` | n/a | yes |
| slack\_api\_token | API token used by the slack client. Located under the slack application Settings > Install App > Bot User OAuth Access Token | `string` | n/a | yes |
| slack\_channel\_id | Channel that the slack notifier will post to | `string` | n/a | yes |
| slack\_signing\_secret | The slack application's signing secret. Located under the slack application Settings > Basic Information | `string` | n/a | yes |
| svc\_user\_dn | Distinguished name of the LDAP Maintenance service account used to manage simpleAD | `string` | n/a | yes |
| svc\_user\_pwd\_ssm\_key | SSM parameter key that contains the LDAP Maintenance service account password | `string` | n/a | yes |
| vpc\_id | ID of the VPC hosting the target Simple AD instance | `string` | n/a | yes |
| additional\_cleanup\_tasks | (Optional) List of step function tasks to execute in parallel once the cleanup action has been approved. | `string` | `""` | no |
| days\_since\_pwdlastset | Number of days since the pwdLastSet ldap attribute has been updated. This metric is used to disable the target ldap object. | `number` | `120` | no |
| enable\_dynamodb\_cleanup | Controls wether to enable the dynamodb cleanup resources. The lambda function and supporting resources will still be deployed. | `bool` | `true` | no |
| hands\_off\_accounts | (Optional) List of user names to filter out of the user search results | `list(string)` | `[]` | no |
| log\_level | (Optional) Log level of the lambda output, one of: Debug, Info, Warning, Error, or Critical | `string` | `"Info"` | no |
| maintenance\_schedule | Periodicity at which to trigger the ldap maintenance step function | `string` | `"cron(0 8 1 * ? *)"` | no |
| manual\_approval\_timeout | Timeout in seconds for the manual approval step. | `number` | `3600` | no |
| project\_name | Name of the project | `string` | `"ldap-maintainer"` | no |
| tags | Map of tags to assign to this module's resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| python\_ldap\_layer\_arn | ARN of the python-ldap layer |
| slack\_listener\_endpoint | API endpoint to use as the slack application's Interactive Components request URL |

<!-- END TFDOCS -->
