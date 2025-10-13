terraform {
  backend "s3" {
    bucket       = "terraform-state-adil"
    key          = "eks-gitops-2048.state"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
