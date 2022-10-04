resource "aws_security_group" "outbound_only" {
  name        = "outbound_only"
  description = "outbound_only"
  vpc_id      = data.aws_vpc.custom.id

  egress = [
    {
      description      = "all outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name      = "outbound_only"
    terraform = "true"
  }
}
