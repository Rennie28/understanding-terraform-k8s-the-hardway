###########################################
# Creating Security Group for Baston Server
###########################################

# resource "aws_security_group" "alb_sg" {
#   name        = "alb_sg-${terraform.workspace}"
#   description = "Allow traffic on port 80"
#   vpc_id      = local.vpc_id

#   ingress {
#     description = "Allow traffic on port 80"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   ingress {
#     description = "Allow traffic on port 443"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb_sg-${terraform.workspace}"
#   }
# }

# ##########################################################
# # Creating Security Group for Private security group
# ##########################################################

# resource "aws_security_group" "static_sg" {
#   name        = "static_sg-${terraform.workspace}"
#   description = "Allow inbound from alb security group id"
#   vpc_id      = local.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   tags = {
#     Name = "static_sg-${terraform.workspace}"
#   }
# }

# ################################################
# # Creating Private Security Group Rule
# ################################################

# resource "aws_security_group_rule" "allow_ssh_from_baston_security_group" {

#   security_group_id        = aws_security_group.static_sg.id
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.alb_sg.id #reference the sg id of the baston/public instance 
# }

# ##########################################################
# # Creating Registration app security group
# ##########################################################

# resource "aws_security_group" "registration_app" {
#   name        = "registration-app-sg-${terraform.workspace}"
#   description = "Allow inbound from alb security group id"
#   vpc_id      = local.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   tags = {
#     Name = "registration-app-sg-${terraform.workspace}"
#   }
# }

# ################################################
# # Creating Registration app security group Rule
# ################################################

# resource "aws_security_group_rule" "registration_security_group" {

#   security_group_id        = aws_security_group.registration_app.id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.alb_sg.id #reference the sg id of the baston/public instance 
# }

# ##########################################################
# # Creating Database security group
# ##########################################################

# resource "aws_security_group" "database_security_group" {
#   name        = "mysql-sg-${terraform.workspace}"
#   description = "Allow inbound from alb security group id"
#   vpc_id      = local.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   tags = {
#     Name = "mysql-sg-${terraform.workspace}"
#   }
# }

# ################################################
# # Creating Database security group Rule
# ################################################

# resource "aws_security_group_rule" "mysql_inbound_security_group" {

#   security_group_id        = aws_security_group.database_security_group.id
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.registration_app.id #reference the sg id of the baston/public instance 
# }
