this = {
  aws_region   = "us-east-1"
  profile      = null #profile used for aws credentials / codebuild / comment out if not running in a pipeline with buildspec
  ec2_backup_duration = 7
  rds_backup_duration = 7
}