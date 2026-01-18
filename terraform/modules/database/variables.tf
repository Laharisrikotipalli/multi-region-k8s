variable "identifier" { type = string }
variable "vpc_id"     { type = string }
variable "vpc_cidr"   { type = string }
variable "subnet_ids" { type = list(string) }
variable "db_username" { 
  type    = string
  default = "postgres" 
}
variable "db_password" { 
  type      = string 
  sensitive = true 
}
variable "is_primary" { 
  type    = bool
  default = false 
}
variable "replicate_source_db" { 
  type    = string
  default = null 
}
variable "backup_retention_period" { 
  type    = number
  default = 0 
}