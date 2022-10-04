## <u>Terraform Standards</u>
<br/>

1. When naming a resource/variable/value etc the name should use snake case.

```
resource "aws_instance" "example_resource" {
  ...
}
```
<br/>

2. Names should always be lower case
<br/>

3. A single instance of a resource should be named `this`

```
resource "aws_instance" "this" {
  ...
}
```
<br/>

4. If more than one resource of a given type is to be created/used then the name should describe its function

```
data "aws_subnet" "app_a" {
...
}

data "aws_subnet" "app_b" {
...
}
```
<br/>

5. The name should not include any information that is present in the Resource/Data source type name
```
data "aws_subnet" "app_subnet_a" {
//The data type already includes the word subnet, do not use the word subnet again for the name of this block
...
}
```
<br/>

## <u> Code Structure </u>
<br/>
You SHOULD use a single file for each of the following:

<br/>

    backend.tf
    data.tf
    main.tf
    outputs.tf
    providers.tf
    variables.tf
 
