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
### IAM Policy
#####################

data "aws_iam_policy_document" "sts_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["backup.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy" "backups" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_iam_policy" "restores" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

data "aws_iam_policy" "s3backup" {
  arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup"
}

data "aws_iam_policy" "s3restore" {
  arn = "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore"
}

