#####################
### Account Information
#####################

data "aws_caller_identity" "current" {}

#####################
### VPC and Roles
#####################

data "aws_vpc" "custom" {
  default = false
}

#####################
### Availability Zones and Subnets
#####################

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.custom.id]
  }
  tags = {
    use = "private"
  }
}

data "aws_subnet" "private_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-private-a"
  }
}

data "aws_subnet" "private_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-private-b"
  }
}

data "aws_subnet" "transport_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-transport-a"
  }
}

data "aws_subnet" "transport_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-transport-b"
  }
}

################
# Target Groups
################

data "aws_lb_target_group" "lb_port_a" {
  name = "${var.this["lb_port_a"]}"
}

#####################
### AMI Info / Instance Profile / Security Groups
#####################

data "aws_ami" "this" {
  most_recent = true
  owners      = ["${var.this["ami_owner"]}"]

  filter {
    name   = "name"
    values = ["${var.this["ami_value"]}"]
  }
}

data "aws_iam_instance_profile" "this" {
  name = "leidos-cloud-base-ec2-profile-v4"
}

data "aws_security_group" "cmscloud_shared_services" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-shared-services"
}

# data "aws_security_group" "private_serv_sg" {
#   vpc_id = data.aws_vpc.custom.id
#   name   = "private_serv_sg"
# }

data "aws_security_group" "cmscloud_vpn" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-vpn"
}

data "aws_security_group" "cmscloud_security_tools" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-security-tools"
}

data "aws_security_group" "data_sg" {
  vpc_id = data.aws_vpc.custom.id
  name   = "data_sg"
}

data "aws_security_group" "outbound_only" {
  vpc_id = data.aws_vpc.custom.id
  name   = "outbound_only"
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/seatool_binaries.ps1")
}
