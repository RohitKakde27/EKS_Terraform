resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "ec2-pipeline-policies" {
    
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codedeploy:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "ec2-pipeline-policy" {
    name = "cicd-ec2-policy"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.ec2-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "ec2-pipeline-attachment" {
    policy_arn = aws_iam_policy.ec2-pipeline-policy.arn
    role = aws_iam_role.ec2-role.id
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2-role.name
}