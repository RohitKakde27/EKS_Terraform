resource "aws_iam_role" "deploy" {
  name = "role_deploy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy.name
}

resource "aws_codedeploy_app" "app-2" {
  compute_platform = "Server"
  name             = "app"
} 

resource "aws_codedeploy_deployment_group" "prod-group" {
    app_name=aws_codedeploy_app.app-2.name
    deployment_group_name="deploy-group1"
    service_role_arn      = aws_iam_role.deploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.resource_tags["Name"]
    }
    
  }
}

