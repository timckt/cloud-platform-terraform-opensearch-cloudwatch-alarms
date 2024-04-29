data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  aws_sns_topic_arn = var.sns_topic
}