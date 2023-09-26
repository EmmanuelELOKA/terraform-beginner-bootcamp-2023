terraform {
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "EmmanuelEloka-terraform-bootcamp"

  #  workspaces {
  #    name = "terra-house-eloka"
  #  }
  #}
  #cloud {
  #  organization = "EmmanuelEloka-terraform-bootcamp"
  #  workspaces {
  #    name = "terra-house-eloka"
  #  }
  #}

}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
}
