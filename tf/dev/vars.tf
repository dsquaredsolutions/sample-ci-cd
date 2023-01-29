variable "common_tags" {
  type = map(string)
}

variable "private_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "certificate_body" {
  type    = string
  default = ""
}

variable "certificate_chain" {
  type    = string
  default = ""
}

variable "name" {
  description = "the name of your platform"
}

variable "environment" {
  description = "the name of your environment"
  default     = "dev"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-east-2"
}

variable "aws_region" {
  type        = string
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/24"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/27", "10.0.0.64/27", "10.0.0.128/27"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.32/27", "10.0.0.96/27", "10.0.0.160/27"]
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 1
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 4444
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "container_image" {
  description = "The image url we want to deploy"
  default     = "dsquaredsolutions/sample-ci-cd"
}

variable "container_tag" {
  description = "The docker image tag we want to deploy"
  default     = "latest"
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/healthz"
}
