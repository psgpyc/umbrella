variable "bucket_name" {

    type = string
    description = "The name for the s3 bucket"

    default = "umbrella-buck"
  
}

variable "tags" {

    type = map(string)

    description = "Tags for the s3 bucket"

    default = {
      "Name" = "umbrella"
      "Type" = "dev"
    }
  
}


variable "transition_rules" {

    type = list(object({

      id = string

      filter = object({
        prefix = optional(string)
        tags = optional(map(string))
        object_size_greater_than = optional(number)
        object_size_less_than = optional(number) 
      })

      transition = list(object({
        days = number
        storage_class = string 
      }) )
      
      expiration = optional(object({
        date = optional(string)
        days = optional(number)
        expired_object_delete_marker = optional(bool)
      }))
      status = string

    }))
}



variable "non_current_transition_rule" {

  type = list(object({

      id = string

      filter = object({
        prefix = optional(string)
        tags = optional(map(string))
        object_size_greater_than = optional(number)
        object_size_less_than = optional(number) 
      })

      non_current_transition = list(object({
        noncurrent_days = number
        storage_class = string 
      }) )

      non_current_expiration = optional(object({
        noncurrent_days = optional(number) 
      }))
      status = string

    }))
}