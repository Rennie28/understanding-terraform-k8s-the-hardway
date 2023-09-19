####################
#IAM Role
###################

resource "aws_iam_role" "ssm_fleet_instance" {
  name = "fleet-instance-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "fleet-instance-${terraform.workspace}"

  }
}


####################
#IAM Policy
###################

resource "aws_iam_policy" "policy" {
  name        = "baston-policy-${terraform.workspace}"
  description = "allow ec2 instance to be managed by ssm"
  policy      = <<EOF
{
  "Version" : "2012-10-17",
  "Statement":[
    {
      "Action":[
        "ssm:UpdateInstanceInformation",
         "ssmmessages:CreateControlChannel",
         "ssmmessages:CreateDataChannel",
         "ssmmessages:OpenControlChannel",
         "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*",
        "Effect": "Allow"
    
      }
    ]
  }
  EOF 
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ssm_fleet_instance.name
  policy_arn = aws_iam_policy.policy.arn

}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ssm-fleet-profile-${terraform.workspace}"
  role = aws_iam_role.ssm_fleet_instance.name
}


