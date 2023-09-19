#################################################################
# NETWORKING PARENT MODULE
################################################################

locals {
  vpc_id = aws_vpc.njemo.id
}

resource "aws_vpc" "njemo" {
  cidr_block           = var.vpc_cidr #create a variable
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.public_subnet_tags,
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = local.vpc_id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidr)

  vpc_id            = local.vpc_id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.database_subnet_tags,
  )
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

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.public_route_table_tags,
  )
}

###################################################
# Creating Public Route Table Association
###################################################

resource "aws_route_table_association" "rt_association" {
  count = length(var.public_subnet_cidr)

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

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

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.default_route_table_tags,
  )
}

###############################################################
# creating a nat gateway
##############################################################

resource "aws_nat_gateway" "natgw" {
  depends_on = [aws_internet_gateway.gw]

  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.nat_gateway_tags,
  )
}

###############################################################
#creating an elastic ip
###########################################################

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.gw]
  vpc        = true
}