# Static Website Deployment on AWS with Terraform

This project demonstrates the use of Infrastructure as Code (IaC) principles by deploying a static website 
to Amazon Web Services (AWS) using Terraform. The infrastructure is fully automated and includes an S3 bucket 
for hosting static files and a CloudFront distribution for global content delivery

##What This Project Does
- Creates an S3 Bucket to host a static website (HTML files).
- Configures a CloudFront Distribution to serve the website globally
- Sets appropriate bucket policies to allow CloudFront access to the S3 bucket (Origin Access Identity)
- Applies the infrastructure using terraform apply to generate and deploy all components
- Outputs a CloudFront domain URL where the deployed website can be accessed in a browser.

## Technologies Used
- Terraform
- AWS S3 – to store and serve static website files
- AWS CloudFront – to distribute content globally with caching
- AWS IAM – for managing permissions and access identity
- Terraform AWS Provider – for managing AWS resources!
![terraform architectural diagram](https://github.com/user-attachments/assets/6b49f640-00ff-4fc6-9b19-42d925cc1e33)
