# Configure the AWS Provider
provider "aws" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.55.0"
}

data "terraform_remote_state" "vpc" {
  backend = "atlas"

  config {
    name = "${var.tfe_org}/${var.vpc_workspace}"
  }
}

data "terraform_remote_state" "sg" {
  backend = "atlas"

  config {
    name = "${var.tfe_org}/${var.sg_workspace}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "filename_lookup" {
  type = "map"

  default = {
    windows = "windows_userdata.tpl"
    linux   = "linux_userdata.tpl"
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/templates/${var.filename_lookup["${var.os}"]}")}"

  vars {
    hello_message = "An example of how to run userdata as template"
  }
}

# Places instances in first subnet 
resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  count                  = "${var.instance_count}"
  vpc_security_group_ids = ["${data.terraform_remote_state.sg.security_group_id}"]
  subnet_id              = "${data.terraform_remote_state.vpc.subnet_id.0}"
  user_data              = "${data.template_file.userdata.rendered}"

  tags {
    Name = "web_${count.index}"
  }
}
