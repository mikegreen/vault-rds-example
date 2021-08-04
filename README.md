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
1. Once provisioned successfully, you should be able to run `$ vault read postgres/creds/my-role`
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

