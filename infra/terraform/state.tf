terraform {
  backend "s3" {
    bucket = "sironazevedo-notifyuploadcomplete-terraform-tfstates"
    region = "us-east-1"
  }
}