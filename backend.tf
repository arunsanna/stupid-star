terraform {
  backend "s3" {
    bucket = "arun-sanna-testing"
    key    = "tf_state"
    region = "us-east-1"
  }
}