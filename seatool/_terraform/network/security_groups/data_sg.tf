resource "aws_security_group" "data_sg" {
  name        = "data_sg"
  description = "data_sg"
  vpc_id      = data.aws_vpc.custom.id

  ingress = [
    {
      description      = "Private Subnets"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [data.aws_subnet.private_a.cidr_block, data.aws_subnet.private_b.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Transport Subnets"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [data.aws_subnet.transport_a.cidr_block, data.aws_subnet.transport_b.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name      = "data_sg"
    terraform = "true"
  }
}