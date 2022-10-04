locals {
  subs   = concat([data.aws_subnet.private_a.id], [data.aws_subnet.private_b.id])
  azs    = tolist(["a", "b", "c"])
  drives = tolist(["d", "e", "f"])
  hostn  = tolist([var.this["hostname-a"], var.this["hostname-b"], var.this["hostname-c"]])
}

##############################
# Create EC2
##############################

resource "aws_instance" "this" {

  count = var.this["inst_count"]
  # ami                         = var.this["ami_id"] 
  ami                         = data.aws_ami.this.id
  instance_type               = var.this["inst_type"]
  subnet_id                   = element(local.subs, count.index)
  vpc_security_group_ids      = [data.aws_security_group.cmscloud_shared_services.id, data.aws_security_group.cmscloud_security_tools.id, data.aws_security_group.data_sg.id, data.aws_security_group.outbound_only.id]
  iam_instance_profile        = data.aws_iam_instance_profile.this.name
  associate_public_ip_address = false
  key_name                    = var.this["key_name"]
  user_data                   = base64encode(data.template_file.user_data.template)

  root_block_device {
    volume_size           = var.this["vol_size"]
    volume_type           = var.this["vol_type"]
    encrypted             = true
    delete_on_termination = true
    tags = {
      Terraform = true
      Name      = "${element(local.hostn, count.index)}-root"
    }
  }
  tags = {
    Name      = "${element(local.hostn, count.index)}"
    Terraform = "true"
    hostname  = "${element(local.hostn, count.index)}"
    launch_runbooks  = false
    ec2_backup = "${var.this["ec2_backup"]}"
    "Patch Window" = "${var.this["patch_window"]}"
    "Patch Group"  = "${var.this["patch_group"]}"
  }

  lifecycle {
    ignore_changes = [ami,tags["launch_runbooks"]] #This will ignore updates if the AMI is newer than what was previously deployed
  }
}


# ###########################
# # Attach EC2 Instance to Target Group
# ###########################

# This resource depends on their being an existing Target Group
# Comment out this code if existing resource does not exist or reference the NLB/ALB code under Networking

resource "aws_lb_target_group_attachment" "this" {
  count             = var.this["inst_count"]
  target_group_arn  = data.aws_lb_target_group.lb_port_a.arn
  target_id         = aws_instance.this[count.index].id #If attaching to ALB this needs to the the ALB ARN
}

# #########################################################
# # Uncomment the below if you need to use additional disks
# #########################################################
# ###########################
# # Create Additional EBS vol
# ###########################

# resource "aws_ebs_volume" "this" {
#   count             = var.this["inst_count"]
#   availability_zone = "${var.this["aws_region"]}${element(local.azs, count.index)}"
#   size              = var.this["sec_vol_size"]
#   type              = var.this["sec_vol_type"]
#   encrypted         = true

#   tags = {
#     Name      = "${element(local.hostn, count.index)}-xvd${element(local.drives, count.index)}"
#     Terraform = true
#   }

#   lifecycle {
#     prevent_destroy = false
#   }
# }

# ########################
# # Create EBS attachments
# ########################

# resource "aws_volume_attachment" "this" {
#   count        = var.this["inst_count"]
#   volume_id    = aws_ebs_volume.this[count.index].id
#   instance_id  = aws_instance.this[count.index].id
#   device_name  = "xvd${element(local.drives, count.index)}"
#   skip_destroy = false
# }