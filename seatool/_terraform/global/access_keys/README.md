# EC2 Access Keys

## Variables

## Global

There is only a single "global" variable defined called `application`. This is set in the variables.tf file and should be updated to your app name.
This variable is used in creating the names of resources.

## Generating new keys

For automatic rotation and the more correct way to manage your secrets in AWS please refer to [AWS secrets manager rotation policies](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html).
The terraform documentation for the service can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation).
Please note that if you generate a new Ec2 access key you will have to update the key on the server(s).
Be sure you have other means, such as SSM, to access the server and update the key before you change it.

### Terraform 0.15 and above

Updating the tls key, the aws access key, and the secrets in secrets manager can be done by replacing the `tls_private_key` resource.

`terraform apply -var-file=env/dev/_dev.tfvars -replace="tls_private_key.example"`

### Terraform < 0.15

First, why is your terraform version so old? Second, this will also work with terraform 0.15 and up but is not the recommended way by Hashicorp.
You can force the creation of a new key by tainting the `tls_private_key` resource. I have not tested if the tfvars flags work with the taint command.

`terraform taint tls_private_key.example`
