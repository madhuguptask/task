variable "name" {
  type = string
}
variable "asg_mixed_instance_types" {}
variable "spot_allocation_strategy" {}
variable "spot_instance_pools" {
  type = number
  default = "2"
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "launch_template" {}

variable "policy_enabled" {
  default = false
  type = bool
}

variable "tags" {
  type = any
}

variable "scale-up-policy" {
  default = false
  type = bool
}

variable "scale-down-policy" {
  default = false
  type = bool
}

variable "on_demand_percentage_above_base_capacity" {
  default = 70
  type = number
}
