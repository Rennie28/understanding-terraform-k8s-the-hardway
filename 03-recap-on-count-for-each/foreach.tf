
# Create a VPC
resource "aws_vpc" "test_vpc_for_each" {
  cidr_block = var.vpc_cidr #Create a variable for this

  tags = {
    Name = "initial-test-vpc"
  }

}

locals {
  # public_subnet = {
  #     pub_subnet_1 = {
  #         cidr_block = "10.0.0.0/24"
  #         az = "us-east-1a"
  #     }

  #     pub_subnet_2 = {
  #         cidr_block = "10.0.2.0/24"
  #         az = "us-east-1b"
  #     }
  # }
  # private_subnet={}
}

variable "subnet" {
  type        = map(any)
  description = "objects of public subnets to be created"
  default = {
    subnet_01 = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "us-east-1a"
    }

    subnet_02 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

#datasource block
##"RESOURCE_NAME.LOCAL_NAME.DESIRED_ARTR"

resource "aws_instance" "test_instance_for_each" {

  for_each = toset(var.test_instance) 
  
  ami           = data.aws_ami.ami.id # use datasouce to download 
  instance_type = "t3.micro"
  key_name = data.aws_key_pair.my_key_pair.key_name # use data source 
#   subnet_id = element ([aws_subnet.subnet_01.id, aws_subnet.subnet_02.id], count.index)
  tags = {
    Name = each.value
  }
}

# resource "aws_instance" "example" {
#   for_each = {
#     "instance-1" = {
#       ami           = "ami-0c55b159cbfafe1f0"
#       instance_type = "t2.micro"
#       subnet_id     = "subnet-123456789"
#       vpc_security_group_ids = ["sg-123456789"]
#       key_name      = "my-key-pair"
#       tags = {
#         Name = "Example Instance 1"
#       }
#     }
#   }
  
#   ami           = each.value.ami
#   instance_type = each.value.instance_type
#   subnet_id     = each.value.subnet_id
#   vpc_security_group_ids = each.value.vpc_security_group_ids
#   key_name      = each.value.key_name
#   tags          = each.value.tags
# }
