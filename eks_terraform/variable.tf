variable "location" {
    default = "us-east-1"
}

variable "os_name" {
    default = "ami-002070d43b0a4f171"
}

variable "key" {
    default = "Key--01"
}

variable "instance-type" {
    default = "t2.micro"
}

variable "vpc-cidr" {
    default = "172.16.0.0/16"
}

variable "subnet1-cidr" {
    default = "172.16.16.0/21"

}


variable "subnet2-cidr" {
    default = "172.16.24.0/21"

}

variable "subent-1_az" {
    default =  "us-east-1a"
}

variable "subnet-2_az"{
    default =  "us-east-1b"
}
