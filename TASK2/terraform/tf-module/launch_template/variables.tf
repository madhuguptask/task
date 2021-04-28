variable "lt_name" {
  type = string
}
variable "iam_instance_profile" {
  type = string
}
variable "image_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list
}
variable "user_data" {
  type = string
}
variable "tags" {
  type = any
}
variable "instance_tags" {
  type = any
}
variable "volume_tags" {
  type = any
}
