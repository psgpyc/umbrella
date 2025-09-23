variable "raw_bucket_name" {

    type = string
    description = "The name for the s3 bucket"

    default = "umbrella-buck"
  
}

variable "processed_bucket_name" {

  type = string
  
}

variable "analytics_bucket_name" {
  
}

variable "raw_bucket_tags" {

    type = map(string)

    description = "Tags for the s3 bucket"

    default = {
      "Name" = "umbrella"
      "Type" = "dev"
    }
  
}


variable "processed_bucket_tags" {

  type = map(string)
  
}

variable "analytics_bucket_tags" {
  
  type = map(string)
  
}


variable "raw_bucket_transition_rules" {

    type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

      transition = list(object({
        days = number
        storage_class = string 
      }) )

      expiration = optional(object({
        days = optional(number)
        expired_object_delete_marker = optional(bool) 

      }))

      status = string

    }))
  
}

variable "processed_bucket_transition_rules" {

    type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

      transition = list(object({
        days = number
        storage_class = string 
      }) )

      expiration = optional(object({
        days = optional(number)
        expired_object_delete_marker = optional(bool) 

      }))

      status = string

    }))
  
}

variable "analytics_bucket_transition_rules" {

    type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

      transition = list(object({
        days = number
        storage_class = string 
      }) )

      expiration = optional(object({
        days = optional(number)
        expired_object_delete_marker = optional(bool) 

      }))

      status = string

    }))
  
}



variable "raw_bucket_noncurrent_transition_rules" {

  type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

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

variable "processed_bucket_noncurrent_transition_rules" {

  type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

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

variable "analytics_bucket_noncurrent_transition_rules" {

  type = list(object({

      id = string

      # filter = object({
      #   prefix = optional(string)
      #   tags = optional(map(string)) 
      #   object_size_greater_than = optional(number)
      #   object_size_less_than = optional(number)
      # })

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