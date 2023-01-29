provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_acm_certificate" "dsquared-cert" {
  private_key       = var.private_key
  certificate_body  = var.certificate_body
  certificate_chain = var.certificate_chain
}

module "vpc" {
  source             = "../modules/vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "../modules/security_groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "../modules/alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = aws_acm_certificate.dsquared-cert.arn
  health_check_path   = var.health_check_path
  container_port      = var.container_port
}

module "ecr" {
  source      = "../modules/ecr"
  name        = var.name
  environment = var.environment
}

module "ecs" {
  source                      = "../modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws_region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_image             = var.container_image
  container_tag               = var.container_tag
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  //aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
}
