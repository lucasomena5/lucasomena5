resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-12345"

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}