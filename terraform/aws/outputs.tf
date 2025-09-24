output "cloudtrail_trail_name" { value = aws_cloudtrail.main.name }
output "cloudtrail_bucket" { value = aws_s3_bucket.ct_logs.bucket }
output "kms_key_id" { value = aws_kms_key.ct_kms.id }
