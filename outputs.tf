output "note1" {
  value = "Bucket with name ${var.bucket_name} and Cloudfront distribution with ID ${aws_cloudfront_distribution.cdn.id} created successfully"
}

output "note2" {
  value = "Arn of ${var.user1_name} is ${aws_iam_user.users[var.user1_name].arn} and arn of ${var.user2_name} is ${aws_iam_user.users[var.user2_name].arn}"
}

output "cdn_id" {
  value = aws_cloudfront_distribution.cdn.id
}

#Data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized. 
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

#Output for arn of cdn
output "cdn_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

output "cdn_status" {
  value = aws_cloudfront_distribution.cdn.status
}

output "cdn_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "region_used" {
  value = var.aws_region
}