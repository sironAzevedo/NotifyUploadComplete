terraform {
  backend "s3" {
    bucket = "orquestrador-terraform-tfstates"
    key    = "orquestrador-terraform-state.tfstate"
    region = "us-east-1"
  }
}