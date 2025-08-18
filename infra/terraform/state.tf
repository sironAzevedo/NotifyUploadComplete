terraform {
  backend "s3" {
    bucket  = "notifyuploadcomplete-terraform-tfstates"
    region  = "us-east-1"
    encrypt = true
  }
}