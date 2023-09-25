terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "EmmanuelEloka-terraform-bootcamp"

  #  workspaces {
  #    name = "terra-house-eloka"
  #  }
  #}
  #cloud {
    #organization = "EmmanuelEloka-terraform-bootcamp"
    #workspaces {
      #name = "terra-house-eloka"
    #}
  #}
  required_providers {
    #random = {
      #source = "hashicorp/random"
      #version = "3.5.1"
    #}
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
}
provider "random" {
  # Configuration options
}