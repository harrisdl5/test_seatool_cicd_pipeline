data "aws_vpc" "custom" {
  default = false
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

# data "aws_subnet" "app_a" {
#   vpc_id = data.aws_vpc.custom.id

#   tags = {
#     Name = "*-east-*-app-a"
#   }
# }

# data "aws_subnet" "app_b" {
#   vpc_id = data.aws_vpc.custom.id

#   tags = {
#     Name = "*-east-*-app-b"
#   }
# }

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

data "aws_subnet" "transport_a" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-east-*-transport-a"
  }
}

data "aws_subnet" "transport_b" {
  vpc_id = data.aws_vpc.custom.id

  tags = {
    Name = "*-east-*-transport-b"
  }
}