locals {
  naming_kms = join("-", ["kms", lower(var.purpose), var.environment, format("%02d", var.number_of_sequence)])
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cmk_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key" "cmk" {
  description             = "Encrypt and Decrypt secrets used by AWS EKS"
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.cmk_policy.json
  is_enabled              = true
  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "cmk_alias" {
  name          = "alias/${local.naming_kms}"
  target_key_id = aws_kms_key.cmk.key_id
}
