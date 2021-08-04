# provider.tf

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# provider "vault" {
#   # address = var.vault_addr
#   # token   = var.vault_token
# }

provider "aws" {
  region = "us-east-2"
}
