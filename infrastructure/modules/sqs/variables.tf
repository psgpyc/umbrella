variable "sqs_queue_name" {

    type = string
  
}

variable "sqs_max_message_size" {

    type = number
    default = 262144 # 256 KB
    description = "Message size in bytes"
  
}

variable "sqs_message_delay_seconds" {

    type = number
    default = 0
    description = "Time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds."
}

variable "sqs_message_retention_seconds" {
    type = number
    default = 345600 # 4 days
  
}

variable "sqs_receive_wait_time_seconds" {
    type = number
    default = 0
    description = "ReceiveMessage call will wait for sepcified time for message to arrive"
}

variable "sqs_visibility_timeout_seconds" {
    type = number
    default = 30
    description = "Messages remain hidden for specified time when the message is being processed by consumer"
  
}

variable "tags" {
    type = map(string)
    default = {
      "Type" = "Umbrella"
    }
  
}

# resource policy

variable "sqs_resource_policy" {

    type = string
    default = null
    description = "Resource access policy for SQS"
  
}

variable "redrive_policy" {

    type = string
    default = null
  
}