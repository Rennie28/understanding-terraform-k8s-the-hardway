

locals {
  vpc_id = aws_vpc.njemo.id
  az     = data.aws_availability_zones.available.names
}

#local.az

resource "aws_vpc" "njemo" {
  cidr_block = var.vpc_cidr #create a variable

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rennie-vpc-${terraform.workspace}"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = local.vpc_id
  tags = {
    Name = "rennie-gw-${terraform.workspace}"
  }
}



resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.az[count.index] #"us-east-1a" #use datasource 
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet-${count.index + 1}-${terraform.workspace}"
  }
}
# resource "aws_subnet" "public_subnet_2" {
#   vpc_id                  = local.vpc_id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public_subnet_2-${terraform.workspace}"
#   }
# }
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_1-${terraform.workspace}"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet_2-${terraform.workspace}"
  }
}
resource "aws_subnet" "database_subnet_1" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "database_subnet_1-${terraform.workspace}"
  }
}
resource "aws_subnet" "database_subnet_2" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "database_subnet_2-${terraform.workspace}"
  }
}
####################################################################
#Creating a Public Route Table and Associated with a Public Subnet
####################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "public-route-table"
  }
}


###################################################
# Creating Public Route Table Association
###################################################

resource "aws_route_table_association" "rt_association" {
  count = length(var.public_subnet_cidr)

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

# resource "aws_route_table_association" "public_subnet_2" {
#   subnet_id      = aws_subnet.public_subnet_2.id
#   route_table_id = aws_route_table.public_route_table.id
# }

###########################################
# Creating a Default Route Table
###########################################

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.njemo.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    #the cidr block id is the same for both nat & igw #this is a nat gateway cidr and its for going out/packets going out only 
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "default-route-table-${terraform.workspace}"

  }
}


###############################################################
# creating a nat gateway
##############################################################

resource "aws_nat_gateway" "natgw" {
  depends_on = [aws_internet_gateway.gw]

  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }
}

###############################################################
#creating an elastic ip
###########################################################

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.gw]
  vpc        = true
}
