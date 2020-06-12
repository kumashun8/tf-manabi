# ローカル変数
locals {
  default_ami = "ami-0c3fd0f5d33134a76"
}

variable "kumashun_instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "example" {
  ami           = local.default_ami
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