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
      id = "ran-rule-234"

      status = "Enabled"

      filter = { }
        

      transition = [ {
        days = 30
        storage_class = "STANDARD_IA"
      },
      
      {
        days = 60
        storage_class = "GLACIER"
      } ]

      expiration = {
        days = 365
      }

    } ]
  
}

