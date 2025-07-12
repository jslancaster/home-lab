terraform {
  backend "s3" {
    bucket = "notasecret-terraform"
    key    = "terraform/homelab"
    region = "us-east-1"
    use_lockfile = true
  }
}