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

data "aws_acm_certificate" "this" {
  domain = var.this["certdomain"]
  most_recent = true
  statuses = ["ISSUED"]
  types = ["IMPORTED"]
}


#####################
### Security Groups
#####################

data "aws_security_group" "outbound_only" {
  vpc_id = data.aws_vpc.custom.id
  name   = "outbound_only"
}


data "aws_security_group" "cmscloud_shared_services" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-shared-services"
}

data "aws_security_group" "transport_sg" {
  vpc_id = data.aws_vpc.custom.id
  name   = "transport_sg"
}