provider "aws" {
  region = "ap-northeast-1"
}

# 外部のデータを参照
# この場合だと 最新の Amazon Linux 2 の AMI
data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  # パブリックな AMI リストからフィルタリングしている
  # name : 属性名, values : 指定したい値
  # name が "amzn2-ami..." のやつをフィルター 
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.20191116.0-x86_64-gp2"]
  }

  # state が "available" のやつをフィルター 
  filter {
    name   = "state"
    values = ["available"]
  }
}

# ローカル変数
locals {
  default_ami = "ami-0c3fd0f5d33134a76"
}

variable "kumashun_instance_type" {
  default = "t3.micro"
}

output "example_instance_id" {
  value = aws_instance.example.id
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  regress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = var.kumashun_instance_type

  tags = {
    Name = "kumashun-tf-ganbaru"
  }

  user_data = <<EOF
    #! /bin/bash

    yum install -y httpd
    systemctl start httpd.service
  EOF
}