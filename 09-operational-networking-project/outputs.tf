
output "vpc_id" {
  description = "vpc id"
  value       = module.networking.vpc_id
}

output "public_subnet" {
  description = "public subnet id"
  value       = module.networking.public_subnet_id
}

output "private_subnet" {
  description = "private subnet id"
  value       = module.networking.private_subnet_id
}

output "database_subnet" {
  description = "database subnet id"
  value       = module.networking.database_subnet_id
}
