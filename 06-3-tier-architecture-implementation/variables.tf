variable "vpc_cidr" {
  type        = string
  description = "vpc network cidr address for rennie vpc"
  # default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = list(any)
  description = "public subnet cidrs"
}

variable "public_instance_type" {
  type        = string
  description = "public instance type"
  default     = "t2.micro"
}

variable "private_instance_type" {
  type        = string
  description = "public instance type"
  default     = "t2.micro"
}

variable "registrationapp_instance_type" {
  type        = string
  description = "public instance type"
  default     = "t2.xlarge"
}

variable "db_name" {
  type        = string
  description = "value for databse"
  default     = "webappdb"
}

variable "instance_class" {
  type        = string
  description = "(optional) describe your variable "
  default     = "db.t2.micro"
}

variable "db_username" {
  type        = string
  description = "(optional) describe your variable "
  default     = "rennietek"
}

variable "port" {
  type        = number
  description = "database port"
  default     = 3306
}

variable "dns_name" {
  description = "this is the dns name that would be used to "
  type        = string
}

variable "subject_alternative_names" {
  type = list(any)
}