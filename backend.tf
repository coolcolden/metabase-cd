
terraform {
  backend "s3" {
    bucket = "pmg-maistodos-demo-state"
    key    = "demo/my.state"
    region = "sa-east-1"
  }
}
