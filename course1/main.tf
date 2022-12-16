provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXARXXUK3JVFDWWFW"
  secret_key = "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"
}
resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0]
  tags = {
    Name : var.environment
  }
}
#3 ways to assign value to var.
#1- tf apply : you get a prompt for value
#2- tf apply -var "subnet_cidr_block=10.0.30.0/24"
#3- define vars file terraform.tfvars or tf apply -var-file
variable "environment" {
  description = "deployment environment"
}
variable "subnet_cidr_block" {
  description = "Subnet cidr block"
  default = "10.0.10.0/24"
  type = string
}
variable "vpc_cidr_block" {
  description = "cpv cidr block "
  
}
variable "cidr_blocks" {
  description = "cidr blocks for vpc and subnets"
  type = list(string)
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.cidr_blocks[1]
  availability_zone = "us-east-1a"
  tags = {
    Name : "subnet-1-development"
  }

}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.96.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name : "subnet-default-development"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}
output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
