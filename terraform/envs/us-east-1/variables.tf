variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "primary_db_arn" {
  type    = string
  default = ""
}