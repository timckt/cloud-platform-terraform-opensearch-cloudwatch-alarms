data "aws_caller_identity" "default" {}

locals {
  aws_sns_topic_arn = var.sns_topic
}