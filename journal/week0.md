# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning :mage:](#semantic-versioning-mage)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
- [Considerations for Linux Distribution](#considerations-for-linux-distribution)
- [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
  * [Shebang Considerations](#shebang-considerations)
  * [Execution Considerations](#execution-considerations)
  * [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle Before, Init, Command](#gitpod-lifecycle---before-init-command)
- [Working Env Vars](#working-env-vars)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
- [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
  * [Getting Started Install (AWS CLI) AWS CLI Env Vars](#getting-started-install-aws-cli-aws-cli-env-vars)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
  * [Terraform Init](#terraform-init)
  * [Terraform Plan](#terraform-plan)
  * [Terraform Destroy](#terraform-destroy)
  * [Terraform Apply](#terraform-apply)
  * [Terraform Lock Files](#terraform-lock-files)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning :mage:

This project is going to utilise semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:
 **MAJOR.MINOR.PATCH**, e.g `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Considerations for Linux Distribution
This project is built against Ubunutu. Please consider checking your Linux Distrubtion and change accordingly to distrubtion needs.

[How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:
```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
## Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we notice that bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli) 

This will keep the Gitpod Task File [.gitpod.yml](.gitpod.yml) tidy.
This allow us an easier to debug and execute manually Terraform CLI install
This will allow better portablity for other projects that need to install Terraform CLI.

### Shebang Considerations
A Shebang (prounced Sha-bang) tells the bash script what program that will interpet the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

### Execution Considerations

When executing the bash script we can use the `./` shorthand notiation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpert it.

eg. `source ./bin/install_terraform_cli`

### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be exetuable at the user mode.
```
chmod u+x ./bin/install_terraform_cli
```
alternatively:

```
chmod 744 ./bin/install_terraform_cli
```
https://en.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle - Before, Init, Command

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Working Env Vars

### env command
We can list out all Enviroment Variables (Env Vars) using the env command

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world`

In the terrminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```
### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

## Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.
```
gp env HELLO='world'
```
All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.

You can also set en vars in the `.gitpod.yml` but this can only contain non-senstive env vars.

## AWS CLI Installation

AWS CLI is installed for the project via the bash script ``./bin/install_aws_cli``

### Getting Started Install (AWS CLI) AWS CLI Env Vars

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```
If it is succesful you should see a json payload return that looks like this:
```
{
    "UserId": "AIDA26GATUKRB4WWHDYEK",
    "Account": "752023824658",
    "Arn": "arn:aws:iam::7520256458668:user/NHGFFYFTD"
}
```
We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.

## Terraform Basics

### Terraform Registry
Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

Providers is an interface to APIs that will allow to create resources in terraform.
Modules are a way to make large amount of terraform code modular, portable and sharable.
Randon Terraform Provider

### Terraform Console
We can see a list of all the Terrform commands by simply typing `terraform`

### Terraform Init
At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

### Terraform Plan
`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

### Terraform Destroy
`teraform destroy` 
This will destroy resources.

You can alos use the auto approve flag to skip the approve prompt eg. `terraform apply --auto-approve`

### Terraform Apply
`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

### Terraform Lock Files
`.terraform.lock.hcl` contains the locked versioning for the providers or modulues that should be used with this project.

The Terraform Lock File should be committed to your Version Control System (VSC) eg. Github

### Terraform State Files
`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be commited** to your VCS.

This file can contain sensentive data.

If you lose this file, you lose knowning the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory
`.terraform directory` contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run terraform login it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create open the file manually here:
```
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```
Provide the following code (replace your token in the file):
```
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```
We have automated this workaround with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)