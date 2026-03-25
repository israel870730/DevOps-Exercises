locals {
  create_bucket = var.create_bucket 

  attach_policy = var.attach_require_latest_tls_policy ||  var.attach_deny_insecure_transport_policy ||  var.attach_deny_incorrect_encryption_headers || var.attach_deny_incorrect_kms_key_sse || var.attach_deny_unencrypted_object_uploads || var.attach_policy

  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
#  grants               = try(jsondecode(var.grant), var.grant)
#  cors_rules           = try(jsondecode(var.cors_rule), var.cors_rule)
  lifecycle_rules      = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
#  intelligent_tiering  = try(jsondecode(var.intelligent_tiering), var.intelligent_tiering)
#  metric_configuration = try(jsondecode(var.metric_configuration), var.metric_configuration)
}