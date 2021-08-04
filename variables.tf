# ./modules/rds/variables.tf

variable "common_tags" {
  description = "Tags to apply to all AWS resources"
  type        = map(string)
  default     = { "owner" = "mike-green", "managed_by" = "terraform", "deleteable" = "yes" }
}

variable "r53_id" {
  type    = string
  default = "Z30WCTDR9QHV42"
}
