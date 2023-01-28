module "vpc" {
  source    = "cloudposse/vpc/aws"
  version   = "2.0.0"
  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  ipv4_primary_cidr_block = var.ipv4_primary_cidr_block

  assign_generated_ipv6_cidr_block = false
}

module "dynamic_subnets" {
  source                  = "cloudposse/dynamic-subnets/aws"
  version                 = "2.0.4"
  namespace               = var.namespace
  stage                   = var.stage
  name                    = var.name
  availability_zones      = ["us-east-1a", "us-east-1b"]
  private_subnets_enabled = false
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = [module.vpc.igw_id]
  ipv4_cidr_block         = [module.vpc.vpc_cidr_block]
}

module "ecs_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["ecs-primary"]

  # Allow unlimited egress
  allow_all_egress = true

  rules = [
    {
      key         = "ssh"
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow SSH from anywhere"
    },
    {
      key         = "HTTP"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTP from inside the security group"
    },
    {
      key         = "NODEJS"
      type        = "ingress"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow ingress to node.js app"
    },
    {
      key         = "HTTPALB"
      type        = "ingress"
      from_port   = 31000
      to_port     = 61000
      protocol    = "tcp"
      cidr_blocks = []
      self        = true
      description = "Allow HTTP from ALB"
    }
  ]

  vpc_id = module.vpc.vpc_id
}