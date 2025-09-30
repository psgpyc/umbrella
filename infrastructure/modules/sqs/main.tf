resource "aws_sqs_queue" "this" {

    name = var.sqs_queue_name
    delay_seconds = var.sqs_message_delay_seconds # messages are instantly available for processing, unless this is set to value other than 0
    max_message_size = var.sqs_max_message_size
    message_retention_seconds = var.sqs_message_retention_seconds # in seconds, the message is retained by SQS
    receive_wait_time_seconds = var.sqs_receive_wait_time_seconds #  ReceiveMessage call will wait for sepcified time for message to arrive
    visibility_timeout_seconds = var.sqs_visibility_timeout_seconds

    redrive_policy = var.redrive_policy

    tags = var.tags
  
}


resource "aws_sqs_queue_policy" "this" {

    count = var.sqs_resource_policy != null ? 1 : 0

    queue_url = aws_sqs_queue.this.id
    policy = var.sqs_resource_policy
  
}