# main.tf


# todo
# connect to aws
# create an RDS instance

module "networking" {
  source      = "./modules/networking/"
  common_tags = var.common_tags
  r53_id      = var.r53_id
  rds_address = module.rds.example-01-address
}

module "rds" {
  source                = "./modules/rds/"
  common_tags           = var.common_tags
  rds_security_group_id = module.networking.rds_security_group_id
}

# create CNAME with R53
# done within networking module
output "address" {
  value = module.rds.example-01-address
}

output "cnamed-rds-fqdn" {
  value = module.networking.rds-fqdn
}

# connect to vault
# create database secret engine with cname

resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["dev", "prod"]

  postgresql {
    connection_url = "postgres://${module.rds.example-01-username}:${module.rds.example-01-password}@${module.networking.rds-fqdn}:${module.rds.example-01-port}/${module.rds.example-01-name}"
  }
}


# # create policies
# resource "vault_policy" "admin-like" {
#   name   = "admin-like-policy"
#   policy = data.vault_policy_document.admin_like_policy_content.hcl
# }

# resource "vault_policy" "metrics" {
#   name   = "metrics-policy"
#   policy = data.vault_policy_document.metrics_policy_content.hcl
# }

# # Create a token with the admin-namespace-only policy
# resource "vault_token" "admin-like" {
#   ttl      = "24h"
#   policies = [vault_policy.admin-like.name]
# }
