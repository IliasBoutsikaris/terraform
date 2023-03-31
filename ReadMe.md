Terraform module for creating 2 users and a bucket. After that creates a Cloudfront distribution and builds it on the s3 bucket.
The module creates 2 users and gives them permissions over the bucket 

Flexible module with all the information stored as variables in the variables.tf file 
To be implemented to your project it must be referenced an the root file 

Run it with terraform plan and then terraform apply. 