
variable "vpc_cidr" {
  type        = string
  description = "Value of the vpc cidr "
}

variable "public_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of public subnet cidr"
}

variable "private_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of private subnet cidr"
}

variable "database_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of database subnet cidr"
}
