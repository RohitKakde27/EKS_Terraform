variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "Region in which AWS resources to be created"
}
  
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    Name    = "project-1",
    environment = "prod"
  }
}
variable "ec2_instance_count" {
  type        = number
  default     = 1
  description = "EC2 Instance Count"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
  description = "Instance Type"
}
variable "git-repo-id" {
  type = string
  description = "Name of the repository in github"
}

variable "git-repo-branch" {
  type = string
  description = "Name of the branch in github"
}
variable codestar_connector_credentials {
    type = string
}
variable "key" {
  description = "EC2 key value pair name"
  type = string
}
