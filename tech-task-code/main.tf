# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_server" {
  ami           = "ami-09e6f87a47903347c"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "ec2-key"

  user_data = file("setup.sh")

  tags = {
    Name = "DynamicWebServer"
  }
}

