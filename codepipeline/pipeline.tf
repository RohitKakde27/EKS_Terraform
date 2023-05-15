resource "aws_iam_role" "tf-codepipeline-role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
    statement{
        sid = ""
        actions = ["codestar-connections:UseConnection"]
        resources = ["*"]
        effect = "Allow"
    }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "cicd-pipeline-policy" {
    name = "cicd_pipeline_policy"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    policy_arn = aws_iam_policy.cicd-pipeline-policy.arn
    role = aws_iam_role.tf-codepipeline-role.id
}

resource "aws_codepipeline" "codepipeline" {
  name     = "prod-pipeline"
  role_arn = aws_iam_role.tf-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.test-786.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
         FullRepositoryId = var.git-repo-id
        BranchName       = var.git-repo-branch
        ConnectionArn = var.codestar_connector_credentials
         OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
      stage {
        name ="Build"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["source_output"]
            output_artifacts = ["build_output"]
            
            configuration = {
                ProjectName = aws_codebuild_project.project-1.id
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Deploy"
            provider = "CodeDeploy"
            version = "1"
            owner = "AWS"
            input_artifacts = ["build_output"]
            configuration = {
                ApplicationName = aws_codedeploy_app.app-2.id
                DeploymentGroupName = aws_codedeploy_deployment_group.prod-group.deployment_group_name

            }
        }
    }
    depends_on = [aws_instance.my-vm]
}   
    



  