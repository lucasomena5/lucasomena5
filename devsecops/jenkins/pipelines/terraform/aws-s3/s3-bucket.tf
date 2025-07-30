resource "random_id" "bucket_suffix" {
  byte_length = 20
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "bucket-${random_id.bucket_suffix.hex}"
}