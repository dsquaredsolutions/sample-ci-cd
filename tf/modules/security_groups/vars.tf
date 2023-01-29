variable "name" {
  description = "the name of your stack"
}

variable "environment" {
  description = "the name of your environment"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
}
