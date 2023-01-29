variable "private_key" {
  type      = string
  sensitive = true
}

variable "certificate_body" {
  type = string
}

variable "certificate_chain" {
  type = string
}
