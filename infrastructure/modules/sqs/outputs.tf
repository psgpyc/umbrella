output "sqs_arn" {
    value = aws_sqs_queue.this.arn
  
}

output "sqs_id" {

    value = aws_sqs_queue.this.id
  
}