terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "af-south-1"
}

# create the name of the s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-unique-bucket-${random_id.bucket_id.hex}"   # static_website_name will be the name of the static website on AWS
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin access identity for static website"
}

# uploading the html file that should be in our s3 bucket (first object)
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.s3_bucket.id  # It has some other properties in the id
  key = "index.html"
  source = "website/index.html"
  etag = filemd5("website/index.html")
  content_type = "text.html"
}

# uploading the error file that should be in our s3 bucket (second object)
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.s3_bucket.id  # It has some other properties in the id
  key = "error.html"
  source = "website/error.html"
  etag = filemd5("website/error.html")
  content_type = "text.html"
}

# add cloudfront distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin { # this where the cloudfront distribution will get its content from
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id = aws_s3_bucket.s3_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path

    }
  }
  enabled = true
  is_ipv6_enabled = true
  default_root_object = var.website_index_document

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = aws_s3_bucket.s3_bucket.id
    forwarded_values {
      query_string = false 

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  tags = {
    Name = "Cloudfront Distribution"
    Environment = "Dev"
  }
}

# s3 bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
          
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2S7SRWC9ICDI2"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::my-unique-bucket-7202b2a5/*"
      }
    ]

  })
}
