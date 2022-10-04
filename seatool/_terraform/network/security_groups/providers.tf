provider "aws" {
  region                  = var.this["aws_region"]
  shared_credentials_file = pathexpand("~/.aws/credentials")
  profile                 = var.this["profile"] #use only if running codebuild / build variable for this in tfvars
}