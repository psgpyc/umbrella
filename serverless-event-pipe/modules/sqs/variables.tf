variable "sqs_queue_name" {
    type = string
  
}

variable "delay_seconds" {

    type = number
    default = 90
  
}

variable "max_message_size" {

    type = number
    default = 2048
  
}

variable "message_retention_seconds" {

    type = number
    default = 86400
  
}

variable "receive_wait_time_seconds" {

    type = number
    default = 10
  
}

variable "tags" {
    type = map(string)

    default = {
      "Type" = "sqs"
    }
  
}

variable "redrive_policy" {

    type = string

    default = null
  
}


variable "sqs_resource_access_policy" {

    type = string
    default = null
  
}

