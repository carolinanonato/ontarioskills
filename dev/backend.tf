terraform {
  backend "s3" {
    bucket = "carolskills23"
    key    = "core-infrastructure-week1/terraform.tfstate"
    region = "us-east-1"
  }
}