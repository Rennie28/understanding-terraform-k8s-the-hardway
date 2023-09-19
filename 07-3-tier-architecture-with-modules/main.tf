# #################################################################
# # NETWORKING CHILD MODULE
# ################################################################

# locals {
#   vpc_id = module.networking.vpc_id
#   public_subnet = module.networking.public_subnet_id
#   private_subnet = module.networking.private_subnet_id
#   database_subnet = module.networking.database_subnet_id
# }


# module "networking" {
#   source = "../08-rennies-modules/networking-modules"

#   vpc_cidr             = "10.0.0.0/16"
#   azs                  = ["us-east-1a", "us-east-1b"]
#   public_subnet_cidr   = ["10.0.0.0/24", "10.0.2.0/24"]
#   private_subnet_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
#   database_subnet_cidr = ["10.0.31.0/24", "10.0.33.0/24"]

#   #//referencing parent module
# }


################################################################
# SINCE VPC AND COMPONENT HAS BEEN DEPLOYED, WE'D FETCH ART USING terraform_remote_state
################################################################

data "terraform_remote_state" "operational_network" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "terrform-remote-state-datasource"
    key    = format("env:/%s/path/evn", terraform.workspace) # "env:/${terraform.workspace}/path/evn"
  }
}
################################################################

locals {
  operation_network = data.terraform_remote_state.operational_network.outputs
  vpc_id            = local.operation_network.vpc_id
  public_subnet     = local.operation_network.public_subnet
  private_subnet    = local.operation_network.private_subnet
  database_subnet   = local.operation_network.database_subnet
}
