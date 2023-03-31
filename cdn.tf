# Creation of the distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  default_root_object = "index.html"
  is_ipv6_enabled = true
  price_class = var.price_class

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  origin {
    domain_name = aws_s3_bucket.s3.bucket_domain_name
    origin_id = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_shield {
      enabled = false
      origin_shield_region = var.origin_shield_region
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id = "S3-${var.bucket_name}"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    compress = true
  }
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name = "${var.bucket_name}.s3.amazonaws.com"
  description = "OAC Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# Cache policy of the distribution
resource "aws_cloudfront_cache_policy" "cache_policy" {
  name = "CachingOptimised"
  comment = "The Same As Caching Optimised"
  default_ttl = 86400
  max_ttl = 31536000
  min_ttl = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "name" {
  bucket = var.bucket_name
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
