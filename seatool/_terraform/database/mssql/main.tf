locals {
  accountid = data.aws_caller_identity.current.account_id
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  tags = {
    Terraform = true
  }
}

#################################
#### Create DB Password
#### Store in Secrets Manager
#################################

resource "aws_secretsmanager_secret" "this" {
  name                    = "${module.db.db_instance_id}-${local.timestamp}"
  description             = "RDS DB password"
  recovery_window_in_days = 30

  lifecycle {
    ignore_changes = [name]
  }

}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = module.db.db_instance_password
}

#####################
#### RDS Module #####
#####################

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "4.1.1"

  identifier = "${var.this["appname"]}${var.this["env"]}db"

  engine               = var.this["engine"]
  engine_version       = var.this["engine_version"]
  family               = var.this["family"]               # DB parameter group
  major_engine_version = var.this["major_engine_version"] # DB option group
  instance_class       = var.this["instance_class"]

  allocated_storage     = var.this["allocated_storage"]
  max_allocated_storage = var.this["max_allocated_storage"]
  storage_encrypted     = true

  username               = var.this["username"]
  create_random_password = true
  random_password_length = 12

  port = 1530

  multi_az               = var.this["multi_az"]
  availability_zone      = var.this["availability_zone"]
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.private.ids
  vpc_security_group_ids = [data.aws_security_group.cmscloud_shared_services.id, data.aws_security_group.cmscloud_security_tools.id, data.aws_security_group.rds_sg.id]

  enabled_cloudwatch_logs_exports = ["agent", "error"]
  maintenance_window              = var.this["maintenance_window"]
  backup_window                   = var.this["backup_window"]
  backup_retention_period         = var.this["backup_retention_period"]
  skip_final_snapshot             = true
  deletion_protection             = false
  auto_minor_version_upgrade      = true

  options = [
    {
      option_name = "SQLSERVER_BACKUP_RESTORE"
      option_settings = [
        {
          name  = "IAM_ROLE_ARN"
          value = aws_iam_role.leidos_cloud_rds_s3_role.arn
        }
      ]
    }
  ]

  create_db_parameter_group = true
  parameters = [
    {
      name  = "clr enabled"
      value = "1"
    },
    {
      name  = "database mail xps"
      value = "1"
    }
  ]

  license_model      = var.this["license_model"]
  timezone           = var.this["timezone"]
  character_set_name = var.this["character_set_name"]

  timeouts = {
    create = "90m"
    update = "90m"
    delete = "90m"
  }

  tags = merge(
    local.tags,
    {
      rds_backup = "7daily"
    }
  )
}

#################################
##### Associate Role to RDS #####
#################################

resource "aws_db_instance_role_association" "s3roleassociation" {
  db_instance_identifier = module.db.db_instance_id
  feature_name           = "S3_INTEGRATION"
  role_arn               = aws_iam_role.leidos_cloud_rds_s3_role.arn
  depends_on             = [module.db.db_instance_id]
}

#################################
##### IAM Role Creation #####
#################################

##### Create role for RDS S3 Integration #####
data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["rds.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "leidos_cloud_rds_s3_role" {
  assume_role_policy   = data.aws_iam_policy_document.rds_assume_role.json
  name                 = "leidos-cloud-rds-s3-role-v1"
  path                 = "/delegatedadmin/developer/"
  permissions_boundary = "arn:aws:iam::${local.accountid}:policy/cms-cloud-admin/developer-boundary-policy"
}

resource "aws_iam_role_policy_attachment" "rds_access_for_s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.leidos_cloud_rds_s3_role.name
}