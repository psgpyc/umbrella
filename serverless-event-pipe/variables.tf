variable "bucket_name" {

    type = string
  
}

variable "tags" {

    type = map(string)
    default = null
}

variable "s3_notif_sns_topic" {

    type = object({
      topic_arn = string
      event_list = list(string)  
    })
    default = null
  
}

variable "s3_notif_queue" {
  type = object({
    sqs_queue_arn = string
    event_list = list(string) 
  })

  default = null

  
}


variable "s3_notif_lambda" {
  type = object({
    lambda_function_arn = string
    event_list = list(string) 
  })

  default = null
  
}

variable "event_list" {

    type = list(string)
    default = null
  
}


variable "rules" {

    type = list(object({
      id = string
      status = string
      transition = optional(list(object({
        days = number
        storage_class = string 
      })))

    # we do not allow expiration by date, use days 
      expiration = optional(object({
        days = optional(number) 
        expired_object_delete_marker = optional(bool)
      }))

    # we do not allow filter based on object sizes 
      filter = optional(object({
        prefix = optional(string)
        tags = optional(map(string)) 
      }))


    }))
  
}

variable "non_current_rules" {
    type = list(object({
      id = string
      status = string
      noncurrent_version_transition = optional(list(object({
        noncurrent_days = number
        storage_class = string 
      })))
      noncurrent_version_expiration = optional(object({
        newer_noncurrent_versions = optional(number)
        noncurrent_days = number 
      }))

      # we do not allow filter based on object sizes 
      filter = optional(object({
        prefix = optional(string)
        tags = optional(map(string)) 
      }))

      
    }))



}


# SNS

variable "sns_topic_name" {

    type = string
  
}



variable "subscriptions" {

    type = list(object({
      name = string
      protocol = string
      endpoint = string 
      filter_policy = optional(string)
      redrive_policy = optional(string)
    }))
  
}

variable "iam_role_name" {
    type = string
  
}


# lambda


variable "source_dir" {

    type = string
  
}

variable "output_path" {

    type = string
  
}

variable "lambda_func_name" {

    type = string
  
}


variable "stage_name" {

    type = string
  
}


# sqs

variable "sqs_queue_name" {
    type = string
  
}

variable "sqs_dlq_name" {
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

variable "sqs_resource_access_policy" {

    type = string
    default = null
  
}

