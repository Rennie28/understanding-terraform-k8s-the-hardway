variable "key_name" {
    type = string 
    description = "name of keypair to download using datasource" 
    default = "rennie-demo-key"
    
}

variable "vpc_cidr" {
  description = "value for vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_01_cidr" {
  description = "value for subnet 1 cidr"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_02_cidr" {
  description = "value for subnet 2 cidr"
  type        = string
  default     = "10.0.1.0/24"
}

variable "test_instance" {
    description = "instance names"
    type = list(any)
    default = ["test_instance_01", "test_instance_02"]

}
