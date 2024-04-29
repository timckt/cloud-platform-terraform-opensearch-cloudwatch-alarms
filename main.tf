data "aws_caller_identity" "default" {}
data "aws_region" "current" {}
locals {
  aws_sns_topic_arn = var.sns_topic
}