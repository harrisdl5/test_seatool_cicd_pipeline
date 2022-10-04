resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds_sg"
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
      description      = "BigMac-VPCCidrs"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.this["bigmac_cidra"]}", "${var.this["bigmac_cidrb"]}"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
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
      description      = "BigMac-VPCCidrs"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["${var.this["bigmac_cidra"]}", "${var.this["bigmac_cidrb"]}"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }

  ]

  tags = {
    Name      = "rds_sg"
    terraform = "true"
  }
}