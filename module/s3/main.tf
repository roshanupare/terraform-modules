resource "aws_s3_bucket" "s3-bucket" {
  count = length(var.bucket_name)
  bucket = "${var.bucket_name[count.index]}-${var.env}"

  tags = {
    Name        = var.tag["name"]
    Environment = var.tag["env"]
  }
}