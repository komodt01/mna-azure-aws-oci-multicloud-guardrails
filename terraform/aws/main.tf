# ---------- Identity info ----------
data "aws_caller_identity" "current" {}

# ---------- KMS key for CloudTrail (with proper policy) ----------
data "aws_iam_policy_document" "ct_kms_policy" {
  statement {
    sid = "EnableIAMUserPermissions"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "AllowCloudTrailUseOfTheKey"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]

    # Bind use to this trail via encryption context
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${var.prefix}-trail"]
    }
  }
}

resource "aws_kms_key" "ct_kms" {
  description             = "${var.prefix} CloudTrail KMS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ct_kms_policy.json
}

resource "aws_kms_alias" "ct_alias" {
  name          = "alias/${var.prefix}-cloudtrail"
  target_key_id = aws_kms_key.ct_kms.id
}

# ---------- S3 bucket for CloudTrail logs ----------
resource "aws_s3_bucket" "ct_logs" {
  bucket        = "${var.prefix}-cloudtrail-logs-${var.region}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "ct_logs_block" {
  bucket                  = aws_s3_bucket.ct_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "ct_logs_versioning" {
  bucket = aws_s3_bucket.ct_logs.id
  versioning_configuration { status = "Enabled" }
}

# ---------- Default bucket encryption (SSE-KMS) ----------
resource "aws_s3_bucket_server_side_encryption_configuration" "ct_logs_sse" {
  bucket = aws_s3_bucket.ct_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.ct_kms.arn
    }
    bucket_key_enabled = true
  }
}

# ---------- Bucket policy (CloudTrail writes + Deny non-KMS uploads) ----------
data "aws_iam_policy_document" "ct_bucket_policy" {
  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.ct_logs.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.ct_logs.arn]
  }

  # Enforce aws:kms for all uploads (covers clients other than CloudTrail)
  statement {
    sid    = "DenyNonKMSEncryptUploads"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.ct_logs.arn}/*"]

    # Deny if header is not aws:kms
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }
    # Deny if header is missing
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }
}

resource "aws_s3_bucket_policy" "ct_logs_policy" {
  bucket = aws_s3_bucket.ct_logs.id
  policy = data.aws_iam_policy_document.ct_bucket_policy.json
}

# ---------- Lifecycle (demo values 30*/365*) ----------
resource "aws_s3_bucket_lifecycle_configuration" "ct_logs_lifecycle" {
  bucket = aws_s3_bucket.ct_logs.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    filter { prefix = "" } # all objects

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

# ---------- Multi-region CloudTrail ----------
resource "aws_cloudtrail" "main" {
  name                          = "${var.prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.ct_logs.id
  kms_key_id                    = aws_kms_key.ct_kms.arn
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  include_global_service_events = true
}
