variable "cluster_name" {
  type = string
}
variable "subnet_ids_for_cluster" {
  type    = list
  default = []
}

variable "security_group_ids" {
  type    = list
  default = []
}

variable "iam_role_arn" {
  type = string
}
variable "k8-version" {
  type = string
}

variable "cluster-tags" {
  type = any
}

variable "endpoint_private_access" {
  type    = bool
}

variable "endpoint_public_access" {
  type    = bool
}

variable "enabled_cluster_log_types" {
  type    = list
  default = []
}

