variable "ingress_rules" {
  type = list
  default = []
}

variable "egress_rules" {
  type = list
  default = []
}

variable "sg-name" {
  type = string
}
variable "sg-description" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "tags" {
  type = map(string)
}