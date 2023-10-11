# Terraform Beginner Bootcamp 2023 - Week 1

- [Terraform Beginner Bootcamp 2023 - Week 1](#terraform-beginner-bootcamp-2023---week-1)
  * [Fixing Tags](#fixing-tags)
  * [Root Module Structure](#root-module-structure)
  * [Terraform and Input Variables](#terraform-and-input-variables)
    + [Terraform Cloud Variables](#terraform-cloud-variables)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
    + [var flag](#var-flag)
    + [var-file flag](#var-file-flag)
    + [terraform.tvfars](#terraformtvfars)
    + [auto.tfvars](#autotfvars)
    + [Order of Terraform Variables](#order-of-terraform-variables)
  * [Dealing With Configuration Drift](#dealing-with-configuration-drift)
    + [What happens if we lose our state file?](#what-happens-if-we-lose-our-state-file-)
    + [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
    + [Fix Manual Configuration](#fix-manual-configuration)
  * [Fix using Terraform Refresh](#fix-using-terraform-refresh)
  * [Terraform Modules](#terraform-modules)
    + [Terraform Module Structure](#terraform-module-structure)
    + [Passing Input Variables](#passing-input-variables)
    + [Modules Sources](#modules-sources)
  * [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
  * [Working with Files in Terraform](#working-with-files-in-terraform)
    + [Fileexists function](#fileexists-function)
    + [Filemd5](#filemd5)
    + [Path Variable](#path-variable)
    + [Terraform Locals](#terraform-locals)
    + [Terraform Data Sources](#terraform-data-sources)
    + [Working with JSON](#working-with-json)
  * [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
    + [Terraform Data](#terraform-data)
    + [Provisioners](#provisioners)
    + [Local-exec](#local-exec)
    + [Remote-exec](#remote-exec)
  * [For Each Expressions](#for-each-expressions)

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```
git tag -d <tag_name>
```

Remotely delete tag
```
git push --delete origin tagname
```
Checkout the commit that you want to retag. Grab the sha from your Github history.
```
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

Terraform Cloud (formerly known as Terraform Enterprise) is a platform provided by HashiCorp for collaborating on and managing infrastructure as code. Terraform Cloud provides a way to centralize and automate your Terraform workflows, including variables management. In Terraform Cloud, variables are used to configure and parameterize your Terraform configurations.

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

If you lose your Terraform state file, it can result in a significant issue that can lead to problems with your infrastructure management. The state file is a critical component of Terraform, as it stores the current state of your infrastructure resources and their mapping to your Terraform configuration. Losing the state file can have various consequences.

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

Terraform Import is a feature that allows you to import existing infrastructure resources into your Terraform configuration. This is particularly useful when you have resources that were created outside of Terraform, and you want to start managing them with Terraform without recreating them.

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

Terraform Modules are a way to encapsulate and reuse parts of your Terraform configurations. They allow you to create reusable and shareable components that define resources, input variables, and outputs. Modules help make your Terraform code more modular, maintainable, and scalable, particularly for larger infrastructure deployments and when working on team projects.

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

### Terraform Locals
Locals allows us to define local variables. It can be very useful when we need transform data into another format and have referenced a varaible.
```
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.
```
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

### Working with JSON

We use the jsonencode to create the json policy inline in the hcl.
```
> jsonencode({"hello"="world"})
{"hello":"world"}
```
[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Changing the Lifecycle of Resources
[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

### Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

### Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec
[Local-Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
This will execute command on the machine running the terraform commands eg. plan apply
```sh
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.
```sh
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions
For each allows us to enumerate over complex data types
```sh
[for s in var.list : upper(s)]
```
This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
