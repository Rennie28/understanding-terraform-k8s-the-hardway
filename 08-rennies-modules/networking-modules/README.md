# networking module

# Usage
module "networking" {
  source = "../08-kojitechs-modules/networking-module"

  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr   = ["10.0.0.0/24", "10.0.2.0/24"]
  private_subnet_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
  database_subnet_cidr = ["10.0.31.0/24", "10.0.33.0/24"]
}
