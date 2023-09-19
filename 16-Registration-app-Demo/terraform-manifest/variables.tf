
variable "image_version" {
    type = string
    description = "container image version"
    default = "f56f73ef6a4a7fb"
}

variable "db_endpoint" {
    type = string
    description = "(optional) describe your variable"
    default = "mysql-dbendpoint"
}

variable "db_username" {
    type = string
    description = "(optional) describe your variable"
    default = "root"
}

variable "db_name" {
  type        = string
  description = "value for database name"
  default     = "webappdb"
}

variable "port" {
  type        = number
  description = "database port"
  default     = 3306
}