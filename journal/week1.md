# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:
```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules

```
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kind of variables:

- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file
  
We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag
The var-file flag is used to specify an external variables file during the execution of a Terraform configuration. This flag allows you to separate your variable values from your configuration files, which can be useful for keeping sensitive or environment-specific information separate from your infrastructure code. You use the var-file flag when running Terraform commands like terraform apply or terraform plan to pass in the variable values stored in the external file. For example: `terraform apply -var-file="my-vars.tfvars"`

### terraform.tvfars
This is the default file to load in terraform variables in blunk

### auto.tfvars
`auto.tfvars` is a special filename used for automatically loading variable values. It's a feature that simplifies the process of providing variable values to your Terraform configurations. Terraform automatically loads variable values from a file named auto.tfvars in the same directory as your Terraform configuration files. This means you don't need to explicitly specify the variable file when running Terraform commands like `apply` or `plan`.

### Order of Terraform Variables
In Terraform, the order of variables is important when it comes to variable declaration and usage within your configuration files.

Variables are typically declared at the beginning of your Terraform configuration. This is done in a variables block within a `.tf file`, often named `variables.tf`. Here, you specify the name, type, and optional default values for each variable.
```
variable "example_var" {
  type    = string
  default = "default_value"
}
```
After declaring variables, you can assign values to these variables in several ways:

1. Direct Assignment: You can assign values directly within the configuration, either by specifying the value inline or referencing other resources' attributes or outputs.
```
resource "example_resource" "example" {
  some_property = var.example_var
}
```
2. Variable Files: You can use variable files, such as `terraform.tfvars` or `auto.tfvars`, to assign values to variables outside of your configuration files. These variable files are written in HashiCorp Configuration Language (HCL) or JSON format and contain variable-value pairs.

Terraform follows a specific order of precedence when resolving variable values. It prioritizes variable values based on the following order (from highest to lowest precedence):

a. Explicitly set values within the configuration.
b. Values provided in variable files (e.g., `terraform.tfvars`, `auto.tfvars`).
c. Default values specified in the variable declaration.

Once variable values are declared and assigned, you can use these variables throughout your configuration to make your infrastructure dynamic and reusable. Variables can be interpolated using the var keyword.
```
resource "example_resource" "example" {
  some_property = var.example_var
}
```
## Dealing With Configuration Drift

### What happens if we lose our state file?

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import
```
terraform import aws_s3_bucket.bucket bucket-name
```
[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS s3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps.

If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift

## Fix using Terraform Refresh
```
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module. The module has to declare the terraform variables in its own variables.tf
```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources
Using the source we can import the module from various places eg:

- locally
- Github
- Terraform Registry
```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexists function
This is a built in terraform function to check the existance of a file.
```
condition = fileexists(var.error_html_filepath)
```
https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called path that allows us to reference local paths:

- path.module = get the path for the current module
- path.root = get the path for the root module [Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```
resource "aws_s3_object" "index_html" { bucket = aws_s3_bucket.website_bucket.bucket key = "index.html" source = "${path.root}/public/index.html" }
```