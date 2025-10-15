resource "aws_sns_topic" "this" {

    name = var.sns_topic_name

    display_name = var.sns_topic_name

    tags = var.tags

}


resource "aws_sns_topic_policy" "this" {

    arn = aws_sns_topic.this.arn

    policy = var.topic_resource_policy
  
}

resource "aws_sns_topic_subscription" "this" {

    for_each = {
      for subs in var.subscriptions: subs.name => subs
    }

    topic_arn = aws_sns_topic.this.arn

    protocol = each.value.protocol

    endpoint = each.value.endpoint

    filter_policy = each.value.filter_policy

    redrive_policy = each.value.redrive_policy


}