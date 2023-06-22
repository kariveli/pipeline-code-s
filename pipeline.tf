
terraform{
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-016eb5d644c333ccb" 
  instance_type = "t2.micro"
  user_data = "${file("app.sh")}"
  vpc_security_group_ids = [ aws_security_group.sg1.id ]
  tags = {
    Name = "linux-server"
  }
}
resource "aws_security_group" "sg1" {
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Resource s3 Bucket
resource "aws_s3_bucket" "terrabucket" {
  bucket = "pipelines3bucket07"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# resource acl
resource "aws_s3_bucket_acl" "bucket-acl" {

  bucket = aws_s3_bucket.terrabucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_object" "index" {
  bucket = "pipelines3bucket07"
  key    = "index.html"
  source = "C:/Users/arifk/Downloads/index.html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("C:/Users/arifk/Downloads/index.html")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "webpage1" {
  bucket = "pipelines3bucket07"
  key    = "photo_2023-03-23_23-16-46.jpg"
  source = "K:/HYD/photo_2023-03-23_23-16-46.jpg"
  acl = "public-read"
  etag = filemd5("K:/HYD/photo_2023-03-23_23-16-46.jpg")
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "staticweb" {
  bucket = aws_s3_bucket.terrabucket.id

  index_document {
    suffix = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}
*/