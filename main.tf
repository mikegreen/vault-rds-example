# main.tf

# create a security group and make route 53 CNAME entry
module "networking" {
  source      = "./modules/networking/"
  common_tags = var.common_tags
  r53_id      = var.r53_id
  rds_address = module.rds.example-01-address
}

# create RDS instance
module "rds" {
  source                = "./modules/rds/"
  common_tags           = var.common_tags
  rds_security_group_id = module.networking.rds_security_group_id
}

# create database secret engine with cname
resource "vault_mount" "db" {
  path = "postgres-rds"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["dev", "prod", "my-role"]

  postgresql {
    connection_url = "postgres://${module.rds.example-01-username}:${module.rds.example-01-password}@${module.networking.rds-fqdn}:${module.rds.example-01-port}/${module.rds.example-01-name}"
  }
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.db.path
  name                = "my-role"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
  default_ttl         = 600
  max_ttl             = 3600
}

# create a dynamic credential from the above db setup
data "vault_generic_secret" "postgres-secret" {
  path = "${vault_mount.db.path}/creds/${vault_database_secret_backend_role.role.name}"
}

output "my-role-creds" {
  sensitive = true
  value     = data.vault_generic_secret.postgres-secret.*
}

# Credentials you can use to populate other modules/etc
output "my-role-username" {
  sensitive = true
  value     = data.vault_generic_secret.postgres-secret.data.username
}

output "my-role-password" {
  sensitive = true
  value     = data.vault_generic_secret.postgres-secret.data.password
}

output "my-role-db-connection" {
  sensitive = true
  value     = vault_database_secret_backend_connection.postgres.postgresql[0].connection_url
}


# should now be able to get creds this way, too
# $ vault read postgres-rds/creds/my-role
# Key                Value
# ---                -----
# lease_id           postgres-rds/creds/my-role/471MMVPhOo70kQUGHzCvQHwg
# lease_duration     10m
# lease_renewable    true
# password           abc-dfdsQva3zbiKr4jDO
# username           v-root-my-role-crsDXs7K3oPrOytAtqsW-1628099343

# further spelunking 
# $ vault lease lookup postgres-rds/creds/my-role/471MMVPhOo70kQUGHzCvQHwg
# $ vault list sys/leases/lookup/postgres-rds/creds/my-role/
