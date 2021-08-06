# vault-rds-example

This repo creates an AWS RDS Postgres instance with an alternate CNAME 
(vs the example-rds-db.cabcdrzahys.us-east-2.rds.amazonaws.com endpoint 
which is region specific), then adds that database to Vault for dynamic
database secrets.

To use:
1. Clone repo
1. Configure your AWS credentials in your console
1. Configure Vault credentials that will allow creation of a secret engine
1. Update your Route 53 zone for the CNAME in the `r53_id` variable
1. Update `common_tags` variable with your tags if desired
1. terraform plan and apply
1. Once provisioned successfully, it will create a set of credentials, and also should be able to run `$ vault read postgres-rds/creds/my-role`
and Vault will create credentials for you by hitting the DB via the CNAME

```
$ vault read postgres/creds/my-role
Key                Value
---                -----
lease_id           postgres/creds/my-role/Nkh2s311Nw1dlfXVSSm
lease_duration     10m
lease_renewable    true
password           ACBDhDALEmthW5C7-jVb
username           v-root-my-role-qlbD7BR9vADFD3t0i-1628099909
```

The generic secret state output should look something like this:
```
    "my-role-creds": {
      "value": [
        {
          "data": {
            "password": "JcA2bFLZC3Om-a0SyUZe",
            "username": "v-token-te-my-role-70ZRQdG6Y5i9hGpq7JsD-1628267184"
          },
          "data_json": "{\"password\":\"JcA2bFLZC3Om-a0SyUZe\",\"username\":\"v-token-te-my-role-70ZRQdG6Y5i9hGpq7JsD-1628267184\"}",
          "id": "postgres-rds/creds/my-role",
          "lease_duration": 600,
          "lease_id": "postgres-rds/creds/my-role/dkmuA7CE4F9qGyEb3cVglhqg",
          "lease_renewable": true,
          "lease_start_time": "RFC1010109",
          "path": "postgres-rds/creds/my-role",
          "version": -1
        }
```
