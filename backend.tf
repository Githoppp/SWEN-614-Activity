terraform {
  backend "s3" {
    bucket         = "rm-github-terraform"   # Actual S3 bucket name
    key            = "terraform/state/terraform.tfstate"  # Path where Terraform stores the state
    region         = "us-east-1"          # AWS region
  }
}
