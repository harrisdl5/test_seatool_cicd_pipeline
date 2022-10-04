# RDS for MSSQL Server

Configuration in this directory creates a set of RDS resources including DB instance, DB subnet group and DB parameter group.

## Usage

To run this example you need to execute:

```bash
$ terraform init -backend-config=env/_envname_backend.tfvars
$ terraform plan -var-file=env/_envname.tfvars
$ terraform apply -var-file=env/_envname.tfvars
```


## Modify the following environment depending on if you are testing or going prod in the main.tf
```hcl
  deletion_protection             = false
  auto_minor_version_upgrade      = true
```

## Update the following parameters as needed for the instance (remove or add additional parameters)
```hcl
  create_db_parameter_group = true
  parameters = [
    {
      name  = "clr enabled"
      value = "1"
    },
    {
      name  = "database mail xps"
      value = "1"
    }
  ]
```

## Ensure cloudwatch logs are set properly
```hcl
  enabled_cloudwatch_logs_exports = ["agent", "error"]
```

</br>

## Option Groups

[Reference](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html)

## Parameter Groups

[Reference](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html)
