
# module "s3" {
#     source = "./08-rennies-modules/s3-parent-module"

#     bucket_name = "test.bucket.rennies"
#     versioning = "Enabled"
# }

########################################################### 
# create 2 ec2 instances making use of count/for-each block
########################################################### 

resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr #(prod,dev,sbx)

  tags = {
    Name = "rennie-vpc-${terraform.workspace}"
  }

}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = var.subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_1-${terraform.workspace}"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = var.subnet_2_cidr
  availability_zone       = "us-east-1b" #var.subnet_2_az  #this accepts just a string and not a list
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_2-${terraform.workspace}"
  }
}
# use for each to create 2 instances
resource "aws_instance" "this" {
  count = 2

  ami           = data.aws_ami.ami.id # use datasouce to download 
  instance_type = "t3.micro"          #(bigger insatnce type and use the same instance type for prod and sbx)
  # key_name      = data.aws_key_pair.my_key_pair.key_name # use data source 
  subnet_id = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id][count.index]
  #  subnet_id = element ([aws_subnet.subnet_01.id, aws_subnet.subnet_02.id], count.index)
  tags = {
    Name = "app-${count.index + 1}-${terraform.workspace}"
  }
}


