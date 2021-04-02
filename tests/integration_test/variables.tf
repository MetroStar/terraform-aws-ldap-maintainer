variable "certificate_arn" {
  type        = string
  description = "ARN of the certificate to back the LDAPS endpoint"
}

variable "target_zone_name" {
  type        = string
  description = "Name of the zone in which to create the simplead DNS record"
}

variable "project_name" {
  type        = string
  default     = "ldapmaint-test"
  description = "Name of the project"
}

variable "directory_name" {
  type        = string
  description = "DNS name of the SimpleAD directory"
}

variable "slack_api_token" {
  description = "API token used by the slack client"
  type        = string
}

variable "slack_channel_id" {
  description = "Channel that the slack notifier will post to"
  type        = string
}

variable "slack_signing_secret" {
  default     = ""
  description = "The slack application's signing secret"
  type        = string
}

variable "key_pair_name" {
  type        = string
  description = "Name of the keypair to associate with the provisioned instance"
}

variable "additional_ips_allow_inbound" {
  type        = list(string)
  default     = []
  description = "List of IP addresses in CIDR notation to allow inbound on the provisioned sg"
}

variable "instance_profile" {
  type        = string
  description = "Name of the instance profile to attach to the provisioned instance"
  default     = ""
}

variable "create_windows_instance" {
  type        = bool
  default     = true
  description = "Boolean used to control the creation of the windows domain member"
}

variable "enable_dynamodb_cleanup" {
  type        = bool
  default     = true
  description = "Controls wether to enable the dynamodb cleanup function. Resources will still be deployed."
}

variable "filter_prefixes" {
  default     = []
  description = "List of user name prefixes to filter out of the user search results"
  type        = list(string)
}

variable "additional_test_users" {
  default     = []
  description = "List of additional test users to create in the target SimpleAD instance"
  type        = list(string)
}

variable "hands_off_accounts" {
  default     = []
  description = "(Optional) List of user names to filter out of the user search results"
  type        = list(string)
}

variable "manual_approval_timeout" {
  description = "Timeout in seconds for the manual approval step."
  type        = number
  default     = 3600
}
