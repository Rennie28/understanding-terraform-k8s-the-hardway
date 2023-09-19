
#################################################################
# NETWORKING CHILD MODULE
################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source = "../08-rennies-modules/networking-modules"

  vpc_cidr             = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
}
