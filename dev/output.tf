output "vpc_id" {
  description = "The ID of the VPC that hosts ECS cluster"
  value       = module.vpc.vpc_id
}
