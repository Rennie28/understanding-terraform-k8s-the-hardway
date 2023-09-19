

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  vpc_id          = module.networking.vpc_id
  public_subnet   = module.networking.public_subnet_id
  private_subnet  = module.networking.private_subnet_id
  database_subnet = module.networking.database_subnet_id
}


module "networking" {
  source = "../08-rennies-modules/networking-modules"

  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr   = ["10.0.0.0/24", "10.0.2.0/24"]
  private_subnet_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
  database_subnet_cidr = ["10.0.31.0/24", "10.0.33.0/24"]

  #//referencing parent module
}

# ################################################################################
# # CREATING SECURITY GROUP FOR BASTON SERVER.
# ################################################################################

resource "aws_security_group" "jump-server" {
  name        = "jump-server"
  description = "Allow traffic on port 80"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jump-server"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "jumpserver-key"
  public_key = file("./templates/public-key")
}

################################################################################
# CREATING PUBLIC EC2 INSTANCE.
################################################################################

resource "aws_instance" "jump-server" {

  ami                    = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  subnet_id              = module.networking.public_subnet_id[0]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.jump-server.id]
  user_data              = file("./templates/jump-server.sh")
  key_name = aws_key_pair.this.key_name
  tags = {
    Name = "jump-server-${terraform.workspace}"
  }

}
