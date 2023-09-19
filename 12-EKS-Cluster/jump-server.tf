# ################################################################################
# # CREATING SECURITY GROUP FOR BASTON SERVER.
# ################################################################################

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
  iam_instance_profile   = aws_iam_instance_profile.eks_profile.name
  vpc_security_group_ids = [aws_security_group.jump-server.id]
  user_data              = file("./templates/jump-server.sh")
  key_name               = aws_key_pair.this.key_name
  tags = {
    Name = "jump-server-${terraform.workspace}"
  }

}
