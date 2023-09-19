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


###############################
#Creating Public Ec2-instance
##############################

resource "aws_instance" "app1" {


  ami                  = data.aws_ami.ami.id
  instance_type        = var.public_instance_type
  subnet_id            = aws_subnet.private_subnet_1.id
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data            = file("${path.module}/templates/app1.sh")
  security_groups      = [aws_security_group.static_sg.id]

  # subnet_id       = aws_subnet.public_subnet[0].id
  # key_name        = "baston-server-key" #key name | create a new one
  # security_groups = [aws_security_group.baston_sg.id]
    lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
    Name = "app1-${terraform.workspace}"
  }
}

################################
# Creating Private Ec2-instance
################################

resource "aws_instance" "app2" {


  ami                  = data.aws_ami.ami.id
  instance_type        = var.private_instance_type #"t3.xlarge"->production env : "t2.micro"->for dev env or any other env
  subnet_id            = aws_subnet.private_subnet_1.id
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  user_data            = file("${path.module}/templates/app2.sh") #its on port 80
  security_groups      = [aws_security_group.static_sg.id]


  # key_name        = "baston-server-key"
  # security_groups = [aws_security_group.private_sg.id]
   lifecycle {
    ignore_changes = [security_groups]
  }
  
  tags = {
    Name = "app2-${terraform.workspace}"
  }
}

################################
# Creating Registration App
################################
resource "aws_instance" "registration_app" {
  depends_on = [aws_db_instance.registration_app_db]

  count         = 2
  ami           = data.aws_ami.ami.id
  instance_type = var.registrationapp_instance_type #"t3.xlarge"->production env : "t2.micro"->for dev env or any other env
  subnet_id     = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id][count.index]

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  security_groups      = [aws_security_group.registration_app.id]
  user_data = templatefile("${path.module}/templates/registration_app.tmpl", #java file 
    {
      hostname            = "${aws_db_instance.registration_app_db.address}"
      port                = "${var.port}"
      db_name             = "${var.db_name}"
      db_username         = "${var.db_username}"
      db_password         = "${random_password.password.result}"
    }
  )
  # key_name        = "baston-server-key"
  # security_groups = [aws_security_group.private_sg.id]
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
    Name = "registration_app-${terraform.workspace}"
  }
}