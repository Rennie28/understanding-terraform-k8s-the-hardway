variable "vpc_cidr" {
  type        = string
  description = "vpc CIDR"
  #default = 10.0.0.0/16
}

variable "subnet_1_cidr" {
  type        = string
  description = "Subnet 01 CIDR"

}

variable "subnet_2_cidr" {
  type        = string
  description = "Subnet 02 CIDR"

}

