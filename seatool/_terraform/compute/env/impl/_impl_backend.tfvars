#### Use one tfvar for backend and variables???

bucket         = "tfstate-seatoolimpl-204488982178"
key            = "cicd_demo_impl/terraform.tfstate"
profile        = null #use for codebuild
region         = "us-east-1"
dynamodb_table = "tf_locks"
encrypt        = true