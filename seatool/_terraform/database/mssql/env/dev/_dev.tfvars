this = {
  aws_region              = "us-east-1"
  profile                 = null
  env                     = "dev"
  appname                 = "seatool"
  engine                  = "sqlserver-ee"    #https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/create-db-instance.html
  engine_version          = "14.00.3401.7.v1" #use if specific version is required, otherwise highest minor version will be chosen by default
  family                  = "sqlserver-ee-14.0"
  major_engine_version    = "14.00"
  instance_class          = "db.m5.xlarge"
  username                = "sqladmin"
  license_model           = "license-included"
  timezone                = "UTC"
  character_set_name      = "SQL_Latin1_General_CP1_CI_AS"
  allocated_storage       = 200
  max_allocated_storage   = 1000
  availability_zone       = "us-east-1a"
  multi_az                = false
  maintenance_window      = "Sun:07:00-Sun:10:00" #UTC
  backup_window           = "05:00-07:00"         #UTC
  backup_retention_period = 7
}