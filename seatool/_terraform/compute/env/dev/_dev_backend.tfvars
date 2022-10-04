
bucket         = "tfstate-seatooldev-360433083926"
key            = "cicd_demo_dev/terraform.tfstate"
#key             = "test_demo/terraform.tfstate"
profile        = null #use for codebuild
region         = "us-east-1"
dynamodb_table = "tf_locks"
encrypt        = true