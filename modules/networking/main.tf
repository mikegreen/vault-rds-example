# ./modules/networking/main.tf
# Create a security group 

variable "common_tags" {}

variable "r53_id" {
  type = string
}

variable "rds_address" {
  type = string
}

resource "aws_security_group" "sg-rds" {
  name        = "rds-open"
  description = "Terribly open sec group"

  # Allow traffic from everywhere #DangerZone
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # all outbound traffic permitted
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags

}

# output the RDS sec group so the RDS module can use it
output "rds_security_group_id" {
  value = aws_security_group.sg-rds.id
}

resource "aws_route53_record" "example-rds" {
  zone_id = var.r53_id
  name    = "example-rds"
  type    = "CNAME"
  ttl     = "300"
  records = [var.rds_address]
}

output "rds-fqdn" {
  value = aws_route53_record.example-rds.fqdn
}
