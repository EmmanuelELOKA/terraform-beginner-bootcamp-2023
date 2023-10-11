# Terraform Beginner Bootcamp 2023 - Week 2

- [Working with Ruby](#working-with-ruby)
  * [Bundler](#bundler)
  * [Install Gems](#install-gems)
  * [Executing ruby scripts in the context of bundler](#executing-ruby-scripts-in-the-context-of-bundler)
- [Sinatra](#sinatra)
- [Terratowns Mock Server](#terratowns-mock-server)
  * [Running the web server](#running-the-web-server)
- [CRUD](#crud)

## Working with Ruby

### Bundler

Bundler is a tool used in the Ruby programming language ecosystem to manage gem dependencies for Ruby projects. A gem is a packaged Ruby application or library. Bundler helps developers handle gem dependencies by providing a consistent environment and ensuring that the correct versions of gems are used in a project.

### Install Gems

You need to create a Gemfile and define your gems in that file.
```
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```
Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

## Sinatra

Sinatra is a lightweight and flexible web application framework for the Ruby programming language. It is often referred to as a "micro-framework" because it provides the essential tools and libraries for building web applications but leaves many decisions about application structure, organization, and features up to the developer. Sinatra is designed to be minimalistic and unobtrusive, making it a popular choice for creating small to medium-sized web applications and APIs. Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server
We can run the web server by executing the following commands:
```
bundle install
bundle exec ruby server.rb
```
All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform Provider resources utilize CRUD. CRUD is an acronym that stands for Create, Read, Update, and Delete, which are the four primary operations for managing resources in most data systems, including infrastructure resources managed by Terraform.

CRUD stands for Create, Read Update, and Delete

#### Create 
This operation involves defining and creating new infrastructure resources. In Terraform, you write configuration code to describe the desired state of your infrastructure, and then you apply this configuration to create the specified resources. This might include creating virtual machines, databases, storage buckets, or any other infrastructure components.

#### Read 
After resources are created, Terraform allows you to query the current state of those resources. You can use Terraform to inspect and retrieve information about existing infrastructure resources. This can be useful for various purposes, such as validating configurations or gathering information for further automation.

#### Update 
When you need to make changes to your infrastructure, you update your Terraform configuration to describe the desired changes. Terraform will then calculate the necessary modifications and apply them to the existing resources. These changes might include updating configurations, scaling resources, or altering attributes of existing infrastructure.

#### Delete 
This operation involves removing infrastructure resources that are no longer needed. In Terraform, you can modify your configuration to remove specific resources or use the terraform destroy command to delete all resources associated with a specific configuration. This helps ensure that you don't incur unnecessary costs or maintain unused infrastructure.

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete
