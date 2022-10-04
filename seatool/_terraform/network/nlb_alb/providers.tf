provider "aws" {
  region                   = var.this["aws_region"]
  shared_credentials_files = ["~/.aws/credentials"]
  #   profile                 = var.this["profile"] #use only if running codebuild
}