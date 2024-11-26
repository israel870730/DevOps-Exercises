
data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "kms_for_s3_policy" {
  name        = "${local.cluster_name}_kms_policy_for_s3_log_bucket"
  description = "Create policy for usage of s3 logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*",
          "logs:DeleteRetentionPolicy",
		  "logs:PutRetentionPolicy"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:s3:::*","arn:aws:s3:::*/*","arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:*:*",
        "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"]
      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms-s3-attach" {
  role       = module.eks_kubernetes_addons.aws_for_fluent_bit.irsa_name
  policy_arn = aws_iam_policy.kms_for_s3_policy.arn
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "s3:ListBucket",
      "s3:Get*"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["${module.eks_kubernetes_addons.aws_for_fluent_bit.irsa_arn}"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }

  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }

    actions = [
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }

}


module "s3_bucket" {
  source =  "../3-bucket/"
  bucket = local.bucket_name

  force_destroy       = true
  acceleration_status = "Suspended"
  request_payer       = "BucketOwner"

  # Bucket policies
  attach_policy                            = true
  policy                                   = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = true
  attach_deny_incorrect_kms_key_sse        = true
  #allowed_kms_key_arn                      = aws_kms_key.kms_key.arn  #aws_kms_key.objects.arn
  attach_deny_unencrypted_object_uploads   = true

  # S3 bucket-level Public Access Block configuration (by default now AWS has made this default as true for S3 bucket-level block public access)
   block_public_acls       = true
   block_public_policy     = true
  # ignore_public_acls      = true
   restrict_public_buckets = true
   tags                    = local.tags

  # S3 Bucket Ownership Controls
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  expected_bucket_owner = data.aws_caller_identity.current.account_id

  acl = "private" # "acl" conflicts with "grant" and "owner"

  versioning = {
    status     = false
    mfa_delete = false
  }

  # server_side_encryption_configuration = {
  #   rule = {
  #     apply_server_side_encryption_by_default = {
  #       kms_master_key_id =  resource.aws_kms_key.kms_key.arn   #aws_kms_key.objects.arn
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }

  lifecycle_rule = [
    {
      id      = "log"
      enabled = true

             expiration = {
               days = var.days
  #             expired_object_delete_marker = true
             }

            noncurrent_version_expiration = {
   #            newer_noncurrent_versions = 1
               days = 1
             }

    } 
  ]

}
