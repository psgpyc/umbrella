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
      expiration = object({
        days = number 
      })
      status = string

    }))


    default = [ {
      id = "current-transition-rule"

      status = "Enabled"

      filter = { }
        

      transition = [ {
        days = 30
        storage_class = "STANDARD_IA"
      },
      
      {
        days = 60
        storage_class = "GLACIER_IR"
      } ]

      expiration = {
        days = 120
      }

    } ]
  
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
      non_current_expiration = object({
        noncurrent_days = number 
      })
      status = string

    }))

    default = [ {
      id = "noncurrent-transition-rule"

      status = "Enabled"

      filter = {
        prefix = null
        tags = null
        object_size_greater_than = null
        object_size_less_than = null
      }
        

      non_current_transition = [ {
        noncurrent_days = 30
        storage_class = "GLACIER_IR"
      },
      
      {
        noncurrent_days = 120
        storage_class = "GLACIER"
      } ]

      non_current_expiration = {
        noncurrent_days = 180 
      }

    } ]

  
}