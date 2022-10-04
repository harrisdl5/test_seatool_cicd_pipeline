bucket         = "tfstate-seatoolprod-635526538414"
key            = "aws_backups/terraform.tfstate"
profile        = null #use for codebuild
region         = "us-east-1"
dynamodb_table = "tf_locks"
encrypt        = true