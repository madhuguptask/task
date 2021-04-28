variable "key_name" {
  description = "The name for the key pair."
  type        = string
  default     = null
}

variable "public_key" {
  description = "The public key material."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to key pair resource."
  type        = map(string)
  default     = {}
}