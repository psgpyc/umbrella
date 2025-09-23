locals {
  transition_rules_cleaned = [
    for rule in var.transition_rules:
    {
      id = rule.id
      status = rule.status
      transition = rule.transition
      expiration = {
        for k,v in coalesce(rule.expiration, {}): k => v if v != null
      }

      filter = {
        for k, v in rule.filter: k => v if v != null
      }
    }
  ]
  noncurrent_transition_rules_cleaned = [
    for rule in var.non_current_transition_rule:
    {
      id = rule.id
      status = rule.status
      non_current_transition = rule.non_current_transition
      non_current_expiration = rule.non_current_expiration

      filter = {
        for k, v in rule.filter: k => v if v != null
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


resource "aws_s3_bucket_lifecycle_configuration" "this" {

    bucket = aws_s3_bucket.this.id

    dynamic "rule" {

        for_each = local.transition_rules_cleaned
        
        content {

            id = rule.value.id

            status = rule.value.status

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
              for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "object_size_greater_than") ? [1]: []

              content {
                object_size_greater_than = rule.value.filter.object_size_greater_than
              }
            }

            dynamic "filter" {
              for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "object_size_less_than") ? [1]: []

              content {
                object_size_less_than = rule.value.filter.object_size_less_than
              }
            }

            dynamic "filter" {
              for_each = length(rule.value.filter) > 1 ? [rule.value.filter] : []

              content {
                dynamic "and" {
                  for_each = [rule.value.filter]

                  content {
                    prefix = try(and.value.prefix, null)
                    tags = try(and.value.tags, null)
                    object_size_greater_than = try(and.value.object_size_greater_than, null)
                    object_size_less_than = try(and.value.object_size_less_than, null)
                              }
                  
                }
              }
              
            }
            dynamic "transition" {

                for_each = rule.value.transition 

                content {
                    days = transition.value.days
                    storage_class = transition.value.storage_class
                  
                }
              
            }


            dynamic "expiration" {

                for_each = length(rule.value.expiration) == 1 && contains(keys(rule.value.expiration), "date") ? [rule.value.expiration]: []

                content {
                    date = expiration.value.date
                }
              
            }

            dynamic "expiration" {

                for_each = length(rule.value.expiration) == 1 && contains(keys(rule.value.expiration), "days") ? [rule.value.expiration]: []

                content {
                    days = expiration.value.days
                }
              
            }

            dynamic "expiration" {

                for_each = length(rule.value.expiration) == 1 && contains(keys(rule.value.expiration), "expired_object_delete_marker") ? [rule.value.expiration]: []

                content {
                    expired_object_delete_marker = expiration.value.expired_object_delete_marker
                }
              
            }
          
        }

    }

    dynamic "rule" {

        for_each = local.noncurrent_transition_rules_cleaned
        content {
          id = rule.value.id

          status = rule.value.status

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
              for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "object_size_greater_than") ? [1]: []

              content {
                object_size_greater_than = rule.value.filter.object_size_greater_than
              }
            }

            dynamic "filter" {
              for_each = length(rule.value.filter) == 1 && contains(keys(rule.value.filter), "object_size_less_than") ? [1]: []

              content {
                object_size_less_than = rule.value.filter.object_size_less_than
              }
            }

            dynamic "filter" {
              for_each = length(rule.value.filter) > 1 ? [rule.value.filter] : []

              content {
                dynamic "and" {
                  for_each = [rule.value.filter]

                  content {
                    prefix = try(and.value.prefix, null)
                    tags = try(and.value.tags, null)
                    object_size_greater_than = try(and.value.object_size_greater_than, null)
                    object_size_less_than = try(and.value.object_size_less_than, null)
                              }
                  
                }
              }
              
            }


          dynamic "noncurrent_version_transition" {

            for_each = rule.value.non_current_transition

            content {
              noncurrent_days = noncurrent_version_transition.value.noncurrent_days
              storage_class = noncurrent_version_transition.value.storage_class
            }
            
          }

          dynamic "noncurrent_version_expiration" {

            for_each = rule.value.non_current_expiration != null ? [rule.value.non_current_expiration]:  []

            content {
                noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
              
            }
            
          }
        }
      
    }
}




