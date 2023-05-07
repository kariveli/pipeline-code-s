provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "foo" {
ami           = "ami-007855ac798b5175e" 
instance_type = "t2.micro"
}
tags = {
    Name = "TF-Instance1"
    resource "aws_s3_bucket" "S3 Bucket" {
  bucket = "aarifkarbuc7"

  tags = {
    Name        = "terrabuc"
  }
    }
}


