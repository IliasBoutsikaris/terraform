# Create two IAM users
resource "aws_iam_user" "users" {
  for_each = {
    (var.user1_name) = {}
    (var.user2_name) = {}
    
  }
  name = each.key
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_membership" "developers_users" {
  for_each = aws_iam_user.users

  name = each.value.name
  users = [each.value.name]
  group = aws_iam_group.developers.name
}


# Create the S3 bucket name"
resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

# Set ACL for the bucket
resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = var.bucket_acl
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = var.versioning_status
  }
}

# Policy for bucket and CloudFront distribution

data "aws_iam_policy_document" "s3_bucket_policy" {
  version = "2012-10-17"

  statement {
    sid       = "Allow User1 Access"
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectVersion",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.users[var.user1_name].arn]
    }
  }

  statement {
    sid       = "Allow User2 Access"
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectVersion",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.users[var.user2_name].arn]
    }
  }

  statement {
    sid       = "Allow CloudFront Access"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_name

  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}