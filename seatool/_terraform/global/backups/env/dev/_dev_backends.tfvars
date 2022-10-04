bucket         = "tfstate-seatooldev-360433083926"
#bucket         = "test-hhy7-tfstate"
key            = "aws_backups/terraform.tfstate"
profile        = null #use for codebuild
region         = "us-east-1"
dynamodb_table = "tf_locks"
encrypt        = true