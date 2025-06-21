# we want the output to print out the s3 bucket name and the cloudfront distribution domain name. This domain
# name is what we will use to access our static website

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}
