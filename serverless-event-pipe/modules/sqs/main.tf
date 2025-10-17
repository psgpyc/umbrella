resource "aws_sqs_queue" "this" {

    name = var.sqs_queue_name

    delay_seconds = var.delay_seconds

    max_message_size = var.max_message_size

    message_retention_seconds = var.message_retention_seconds

    receive_wait_time_seconds = var.receive_wait_time_seconds

    redrive_policy = var.redrive_policy

    tags = var.tags
  
}

resource "aws_sqs_queue_policy" "this" {

    count = var.sqs_resource_access_policy != null ? 1: 0

    queue_url = aws_sqs_queue.this.id

    policy = var.sqs_resource_access_policy

}

