terraform {
  backend "s3" {
    bucket = "eks-tfstate-bucket"
    key = "eks/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

