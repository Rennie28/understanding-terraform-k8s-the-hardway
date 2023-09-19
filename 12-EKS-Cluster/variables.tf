variable "vpc_cidr" {
  type        = string
  description = "Value of the vpc cidr "
  default     = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of public subnet cidr"
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of private subnet cidr"
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "database_subnet_cidr" {
  type        = list(any)
  description = "Mandatory List of database subnet cidr"
  default     = ["10.0.5.0/24", "10.0.7.0/24"]
}

variable "component_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "rennietchs-eks-demo"
}
