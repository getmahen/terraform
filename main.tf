#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-a2a469e9
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-pony
#


# DEFINE REMOTE BACKEND - IN THIS CASE IT IS ATLAS
terraform {
  backend "atlas" {
    name = "getmahen/training"
  }
}

module "example_module" {
  source  = "./example-module"
  command = "echo Helllllooooooooooo!"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "instance_count" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "web" {
  # ...
  ami                    = "ami-d651b8ac"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-a2a469e9"
  vpc_security_group_ids = ["sg-2788a154"]
  count                  = "${var.instance_count}" #CREATES TWO INSTANCES

  tags {
    "Identity" = "NWI-vault-pony"
    "Name"     = "tf_example"
    "foo"      = "bar"
    "Name"     = "${format("web-%03d", count.index + 1)}"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
