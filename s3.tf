resource "aws_s3_bucket" "b" {
  bucket = "engdevopsb03bucket001"
  acl    = "private"
  # tags = {
  #   Name        = "My bucket"
  #   Environment = "Dev"
  # }
  tags = local.common_tags
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_flow_log" "flowlog" {
  log_destination      = "${aws_s3_bucket.b.arn}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = "${aws_vpc.default.id}"
    lifecycle {
    create_before_destroy = true
  }
}
