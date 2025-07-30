resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-905418039818"

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}