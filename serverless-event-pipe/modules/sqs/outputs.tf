output "queue_arn" {
    value = aws_sqs_queue.this.arn
  
}

output "queue_id" {

    value = aws_sqs_queue.this.id
  
}