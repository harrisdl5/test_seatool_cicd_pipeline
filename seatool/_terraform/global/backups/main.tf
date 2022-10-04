resource "aws_backup_plan" "ec2" {
  name = "ec2_daily_backups"

  rule {
    rule_name         = "ec2_daily"
    target_vault_name = aws_backup_vault.ec2.name
    schedule          = "cron(0 7 ? * * *)"
    lifecycle {
      delete_after = "${var.this["ec2_backup_duration"]}"
    } 
  }
  tags = {
    Delete_After = "${var.this["ec2_backup_duration"]}"
   }
}

resource "aws_backup_plan" "rds" {
  name = "rds_daily_backups"

  rule {
    rule_name         = "rds_daily"
    target_vault_name = aws_backup_vault.rds.name
    schedule          = "cron(0 7 ? * * *)"
    lifecycle {
      delete_after = "${var.this["rds_backup_duration"]}"
    }
  }
  tags = {
    Delete_After = "${var.this["rds_backup_duration"]}"
   }
}

resource "aws_backup_vault" "ec2" {
  name = "ec2_backup_vault"
}

resource "aws_backup_vault" "rds" {
  name = "rds_backup_vault"
}

resource "aws_backup_selection" "ec2" {
  iam_role_arn = aws_iam_role.this.arn
  name         = "ec2_backup_selection"
  plan_id      = aws_backup_plan.ec2.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "ec2_backup"
    value = "true"
  }
}

resource "aws_backup_selection" "rds" {
  iam_role_arn = aws_iam_role.this.arn
  name         = "rds_backup_selection"
  plan_id      = aws_backup_plan.rds.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "rds_backup"
    value = "true"
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.sts_assume_role.json
  name               = "leidos-AWSBackups"
  path = "/delegatedadmin/developer/"
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cms-cloud-admin/developer-boundary-policy"
}

resource "aws_iam_policy" "iam_passrole" {
    name = "iam_passrole"
    path = "/delegatedadmin/developer/"
    policy = file("../../../../../_iam_documents/iam_passrole.json")
}

 resource "aws_iam_role_policy_attachment" "restores" {
   policy_arn = data.aws_iam_policy.restores.arn
   role       = aws_iam_role.this.name
}

 resource "aws_iam_role_policy_attachment" "backups" {
   policy_arn = data.aws_iam_policy.backups.arn
   role       = aws_iam_role.this.name
}

 resource "aws_iam_role_policy_attachment" "s3backup" {
   policy_arn = data.aws_iam_policy.s3backup.arn
   role       = aws_iam_role.this.name
}

 resource "aws_iam_role_policy_attachment" "s3restore" {
   policy_arn = data.aws_iam_policy.s3restore.arn
   role       = aws_iam_role.this.name
}

 resource "aws_iam_role_policy_attachment" "passrole" {
   policy_arn = aws_iam_policy.iam_passrole.arn
   role       = aws_iam_role.this.name
}