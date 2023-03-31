#Bucket name
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
  default     = "iliasbuckett"
}

#User 1 name
variable "user1_name" {
  type        = string
  description = "The name of user 1"
  default     = "api.hq"
}
#User 2 name 
variable "user2_name" {
  type        = string
  description = "The name of user 2"
  default     = "api.my"
}

#Bucket Acl
variable "bucket_acl" {
  type        = string
  description = "The ACL for the S3 bucket"
  default     = "private"
}

#Bucket versioning
variable "versioning_status" {
  type        = string
  description = "The status of S3 bucket versioning"
  default     = "Disabled"
}

#Beggining of variables of Cloudfront Distribution

#Price Class of Bucket 
variable "price_class" {
  type = string
  description = "The price class of the distribution"
  default = "PriceClass_100"
}


#Origin shield region
variable "origin_shield_region" {
    type = string
    description = "What origin shield we use"
    default = "eu-central-1"  
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

