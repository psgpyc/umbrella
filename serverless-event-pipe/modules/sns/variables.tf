variable "sns_topic_name" {

    type = string
  
}

variable "topic_resource_policy" {

    type = string
  
}

variable "tags" {

    type = map(string)
  
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

