#


## <u> Launch EC2 </u>

Initialize the backend - specifying the backend variable file for the environment (dev/impl/prod)

```hcl
terraform init -backend-config=env/dev/_dev_backend.tfvars
```
Run Terraform apply with the variable file specified for the environment
```hcl
terraform apply -var-file=env/dev/_dev.tfvars
```
Destroy should reference the same variable file
```hcl
terraform destroy -var-file=env/dev/_dev.tfvars
```

## <u> Backend Config </u>

</br>

All buckets for terraform for the environments are:
```
tfstate-<appenv>-<awsaccountid>
```
Key should describe the resource or service deploying

```
key            = "compute_demo/terraform.tfstate"
```
Profile is used for CICD and is where the STS keys are stored when authentication
```
profile        = null #use for codebuild
```

## Variables

All variables are referenced via the env/{env}/_dev/impl/prod.tfvars.
Varables in variables.tf are left null generally
Null variables in the files will be ignored (so if you don't want to use var.profile, set it to null)

