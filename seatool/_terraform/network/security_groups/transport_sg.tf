resource "aws_security_group" "transport_sg" {
  name        = "transport_sg"
  description = "transport_sg"
  vpc_id      = data.aws_vpc.custom.id

  ingress = [
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
    },
    {
      description      = "CMSnet Subnets"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.this["cmsnet"]}"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name      = "transport_sg"
    terraform = "true"
  }
}