provider "aws" {
  region                  = var.this["aws_region"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = null # use only if running codebuild
}