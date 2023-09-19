########################################################### 
# create 2 ec2 instances making use of count/for-each block
########################################################### 

# resource "aws_vpc" "test_vpc" {
#   cidr_block = var.vpc_cidr  #Create a variable for this

#   tags = {
#     Name = "initial-test-vpc"
#       }

#   }

# resource "aws_subnet" "subnet_01" {
#   vpc_id     = aws_vpc.test_vpc.id
#  cidr_block = var.subnet_01_cidr
# availability_zone = "us-east-1a"
#   tags = {
#   Name = "subnet_01"
#  }
# }

# resource "aws_subnet" "subnet_02" {
#   vpc_id     = aws_vpc.test_vpc.id
#  cidr_block = var.subnet_02_cidr
# availability_zone = "us-east-1b"    #var.subnet_2_az  #this accepts just a string and not a list
#   tags = {
#   Name = "subnet_2"
#  }
# }
# # use for each to create 2 instances
# resource "aws_instance" "this" {
# count = 2

#   ami           = data.aws_ami.ami.id # use datasouce to download 
#   instance_type = "t3.micro"
#  key_name = data.aws_key_pair.my_key_pair.key_name # use data source 
#  subnet_id = [aws_subnet.subnet_01.id, aws_subnet.subnet_02.id] [count.index]
# #  subnet_id = element ([aws_subnet.subnet_01.id, aws_subnet.subnet_02.id], count.index)
#   tags = {
#     Name = "app-${count.index +1}"
#   }
# }


