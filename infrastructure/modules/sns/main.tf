resource "aws_sns_topic" "this" {

    name =  var.sns_topic_name

    delivery_policy = var.sns_topic_delivery_policy

    tags = var.sns_tags
  
}


resource "aws_sns_topic_policy" "this" {

    arn = aws_sns_topic.this.arn

    policy = var.sns_topic_resource_access_policy
  
}