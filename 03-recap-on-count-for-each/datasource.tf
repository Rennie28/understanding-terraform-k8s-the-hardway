data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"] #amzn2-ami-kernel-5.10-hvm-2.0.20230207.0-x86_64-gp2
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}
#pull-dpwn/download keypair

data "aws_key_pair" "my_key_pair" {
  key_name           = var.key_name
  include_public_key = true

}