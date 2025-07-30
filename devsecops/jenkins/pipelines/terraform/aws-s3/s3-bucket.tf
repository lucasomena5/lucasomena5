resource "random_id" "bucket_suffix" {
  byte_length = 6
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-${random_id.bucket_suffix.hex}"
}