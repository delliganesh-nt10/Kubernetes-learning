terraform {
  backend "s3" {
    bucket         = "flask-notes-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "flask-notes-terraform-locks"
    encrypt        = true
  }
}
