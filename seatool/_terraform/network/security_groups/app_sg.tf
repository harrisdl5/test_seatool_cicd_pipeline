## Uncomment if app subnet created and need app_sg default group


# resource "aws_security_group" "app_sg" {
#   name        = "app_sg"
#   description = "app_sg"
#   vpc_id      = data.aws_vpc.custom.id

#   ingress = [
#     {
#       description      = "Private Subnets"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = [data.aws_subnet.private_a.cidr_block, data.aws_subnet.private_b.cidr_block]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#     {
#       description      = "App Subnets"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = [data.aws_subnet.app_a.cidr_block, data.aws_subnet.app_b.cidr_block]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#     {
#       description      = "Transport Subnets"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = [data.aws_subnet.transport_a.cidr_block, data.aws_subnet.transport_b.cidr_block]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     }
#   ]

#   tags = {
#     Name      = "app_sg"
#     terraform = "true"
#   }
# }