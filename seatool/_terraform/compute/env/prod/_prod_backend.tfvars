#### Use one tfvar for backend and variables???

bucket         = "tfstate-seatoolprod-635526538414"
key            = "cicd_demo_prod/terraform.tfstate"
profile        = null #use for codebuild
region         = "us-east-1"
dynamodb_table = "tf_locks"
encrypt        = true