terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "EmmanuelEloka-terraform-bootcamp"

  #  workspaces {
  #    name = "terra-house-eloka"
  #  }
  #}
  cloud {
    organization = "EmmanuelEloka-terraform-bootcamp"
    workspaces {
      name = "terra-house-eloka"
    }
  }

}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_arcanum_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.arcanum.public_path
  content_version = var.arcanum.content_version
}

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023!"
  description = <<DESCRIPTION
Arcanum, a 2001 title, was initially plagued by a plethora of bugs upon its release. 
However, dedicated modders have painstakingly eradicated these issues, resulting in 
an immensely enjoyable gaming experience, even if the graphics appear somewhat dated. 
Here is my comprehensive guide, which will assist you in playing Arcanum without 
revealing any spoilers from the plot.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url(important)
  domain_name = module.home_arcanum_hosting.domain_name
  town = "missingo"
  content_version = var.arcanum.content_version
}

module "home_zanzibar_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.zanzibar.public_path
  content_version = var.zanzibar.content_version
}

resource "terratowns_home" "home_zanzibar" {
  name = "Visiting ZANZIBAR in 2023!"
  description = <<DESCRIPTION
Embark on a mesmerizing journey to the enchanting island of Zanzibar, where the 
turquoise waters of the Indian Ocean meet the rich tapestry of Swahili culture. 
Explore this hidden gem and discover pristine beaches, spice markets, and historic 
sites. Our comprehensive Zanzibar travel guide will help you uncover the island's 
most breathtaking attractions, indulge in exquisite local cuisine, and immerse 
yourself in the vibrant history and traditions of this captivating destination. 
Join us on an unforgettable adventure to Zanzibar, where every moment is a 
postcard-worthy memory waiting to be captured
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url(important)
  domain_name = module.home_zanzibar_hosting.domain_name
  town = "missingo"
  content_version = var.zanzibar.content_version
}