data "aws_account_primary_contact" "cloud_user" {}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-${data.aws_account_primary_contact.cloud_user.account_id}"
}