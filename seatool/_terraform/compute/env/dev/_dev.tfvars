this = {
    aws_region   = "us-east-1"
    profile      = null #profile used for aws credentials / codebuild / comment out if not running in a pipeline with buildspec
    inst_count   = "1"
    inst_type    = "m5.xlarge"
    key_name     = "seatool-dev"
    ami_owner    = "743302140042"          #Owner of the private AMI being used
    ami_value    = "win2016-gi-*"          #AMI Name being shared
    ami_id       = "ami-0ed9277fb7eb570c9" #Marketplace AMI - to use comment/uncomment ami line in main.tf
    prefix       = "seadappa02"
    hostname-a   = "seadappa02"
    hostname-b   = null
    hostname-c   = null
    vol_size     = "50"
    vol_type     = "gp2"
    sec_vol_size = "80"
    sec_vol_type = "gp3"
    lb_port_a    = "80"
    patch_window = "ITOPS-Wave1-Non-Mktplc-DevTestImpl-MW"
    patch_group  = "Windows"
    ec2_backup   = "true"
}