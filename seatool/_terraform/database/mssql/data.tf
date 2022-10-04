#####################
### Account Information
#####################

data "aws_caller_identity" "current" {}

data "aws_vpc" "custom" {
  default = false
}

#####################
### Security Groups
#####################

data "aws_security_group" "cmscloud_shared_services" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-shared-services"
}

data "aws_security_group" "cmscloud_security_tools" {
  vpc_id = data.aws_vpc.custom.id
  name   = "cmscloud-security-tools"
}

data "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.custom.id
  name   = "rds_sg"
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
    Name = "*-east-*-private-a"
  }
}

data "aws_subnet" "private_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-east-*-private-b"
  }
}

data "aws_subnet" "mgmt_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-east-*-management-a"
  }
}

data "aws_subnet" "mgmt_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-east-*-management-b"
  }
}