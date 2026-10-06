terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }

  backend "s3" {
    bucket = "francisco-guardado-terraform-state"
    key    = "books-static-site/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudFront metrics are only published to us-east-1 — required for CloudWatch alarms
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
