locals {
    default_expiration = { days = null, expired_object_delete_marker = null }
    default_filter = {prefix=null, tags=null}
    default_noncurrent_version_expiration = {newer_noncurrent_versions = null, noncurrent_days = null }
    rules_cleaned = [
        for rule in var.rules:
            {
                id = rule.id
                status = rule.status
                transition = rule.transition 
                expiration = {
                    for k, v in coalesce(rule.expiration, local.default_expiration): k => v if v != null 
                }
                filter = {
                    for k,v in coalesce(rule.filter, local.default_filter): k => v if v != null
                }
            }

    ]

    non_current_rules_cleaned = [
        for rule in var.non_current_rules: {
            id = rule.id
            status = rule.status
            noncurrent_version_transition = rule.noncurrent_version_transition
            noncurrent_version_expiration = {
                    for k,v in coalesce(rule.noncurrent_version_expiration, local.default_noncurrent_version_expiration): k => v if v != null
                }
            filter = {
                    for k,v in coalesce(rule.filter, local.default_filter): k => v if v != null
                }
            }
        ]

}



resource "aws_s3_bucket" "this" {

    bucket = var.bucket_name

    tags = var.tags
  
}

resource "aws_s3_bucket_versioning" "this" {

    bucket = aws_s3_bucket.this.id

    versioning_configuration {

      status = "Enabled"
    
    }
  
}

resource "aws_s3_bucket_notification" "this" {

    bucket = aws_s3_bucket.this.id

    dynamic "topic" {

        for_each = var.s3_notif_sns_topic != null ? [var.s3_notif_sns_topic] : []

        content {
            topic_arn = topic.value.topic_arn
            events = topic.value.event_list
          
        }
    }


    dynamic "queue" {

        for_each = var.s3_notif_queue != null ? [var.s3_notif_queue]: [] 

        content {
            queue_arn = queue.value.sqs_queue_arn
            events = queue.value.event_list

        }

       
      
    }

    dynamic "lambda_function" {

        for_each = var.s3_notif_lambda != null ? [var.s3_notif_lambda] : []

        content {
          lambda_function_arn = lambda_function.value.lambda_function_arn
          events = lambda_function.value.event_list
        }
      
    }

    
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {

    bucket = aws_s3_bucket.this.id

    dynamic "rule" {

        for_each = local.rules_cleaned

        content {

            id = rule.value.id

            status = rule.value.status

            dynamic "transition" {

                for_each = rule.value.transition

                content {
                  days = transition.value.days
                  storage_class = transition.value.storage_class
                }
              
            }

            dynamic "expiration" {

                for_each = length(rule.value.expiration) == 1 && contains(keys(rule.value.expiration), "days") ? [rule.value.expiration] : [] 

                content {
                  days = expiration.value.days
                }
              
            }

            dynamic "expiration" {

                for_each = length(rule.value.expiration) == 1 && contains(keys(rule.value.expiration), "expired_object_delete_marker") ? [rule.value.expiration] : []

                content {
                  expired_object_delete_marker = expiration.value.expired_object_delete_marker
                }
              
            }

            dynamic "filter" {

                for_each = length(rule.value.filter) == 0 ? [1]: []

                content {
                  
                }
              
            }

            dynamic "filter" {

                for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "prefix") ? [1]: []

                content {
                  prefix = rule.value.filter.prefix
                }
              
            }

            dynamic "filter" {
                for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "tags") ? [1]: []

                content {
                  and {
                    tags = rule.value.filter.tags
                  }
                }
              
            }

            dynamic "filter" {
                for_each = length(rule.value.filter) == 2 ? [rule.value.filter] : []

                content {
                    and {
                        prefix = filter.value.prefix
                        tags = filter.value.tags
                    }
                }
              
            }
          
        }
      
    }

    dynamic "rule" {

        for_each = local.non_current_rules_cleaned

        content {

            id = rule.value.id

            status = rule.value.status

            dynamic "noncurrent_version_transition" {
                for_each = length(rule.value.noncurrent_version_transition) == 0 ? [] : rule.value.noncurrent_version_transition

                content {
                  noncurrent_days = noncurrent_version_transition.value.noncurrent_days
                  storage_class = noncurrent_version_transition.value.storage_class

                }
              
            }


            dynamic "noncurrent_version_expiration" {

                for_each = length(rule.value.noncurrent_version_expiration) == 0 ? [] : [rule.value.noncurrent_version_expiration]

                content {
                    newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
                    noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
                  
                }
              
            }

            dynamic "filter" {

                for_each = length(rule.value.filter) == 0 ? [1] : []

                content {
                  
                }
              
            }

            dynamic "filter" {

                for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "prefix") ? [1] : []

                content {
                    prefix = rule.value.filter.prefix
                } 
              
            }

            dynamic "filter" {

                for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "tags") ? [1] : []

                content {
                  and {
                    tags = rule.value.filter.tags
                  }
                }
              
            }

            dynamic "filter" {
                for_each = length(rule.value.filter) == 2 ? [rule.value.filter] : []

                content {
                    and {
                        prefix = filter.value.prefix
                        tags = filter.value.tags
                    }
                }
              
            }




          
        }
      
    }

    






  
}