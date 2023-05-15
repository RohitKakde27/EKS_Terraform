
resource "aws_instance" "my-vm" {
  ami                    = "ami-05ba3a39a75be1ec4"
  instance_type          = var.ec2_instance_type
  key_name               = var.key
  count                  = var.ec2_instance_count
   user_data              = <<-EOF
#!/bin/bash
sudo apt-get update -y

sudo apt-get install ruby -y
sudo apt-get install wget -y
cd /home/ubuntu
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# INSTALL NODEJS - ONLY FOR UBUNTU
sudo apt install nodejs -y

# INSTALL NPM & PM2 - ONLY FOR UBUNTU
sudo apt install npm -y
sudo npm install pm2@latest -g

EOF
  tags = var.resource_tags
vpc_security_group_ids = [aws_security_group.code-sg.id]
iam_instance_profile = aws_iam_instance_profile.ec2-profile.id
}


  locals {
  ports = [80, 443,22, 3000]
}
resource "aws_security_group" "code-sg" {
  name        = "code-sg"
  description = "Dev VPC Default Security Group"


  dynamic "ingress" {
    for_each = local.ports 
    content {
      description = "description ${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


