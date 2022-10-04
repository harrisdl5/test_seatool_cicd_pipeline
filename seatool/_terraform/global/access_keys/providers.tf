provider "aws" {
  region                  = var.this["aws_region"]
  shared_credentials_file = pathexpand("~/.aws/credentials")
  profile                 = null # use only if running codebuild
}
