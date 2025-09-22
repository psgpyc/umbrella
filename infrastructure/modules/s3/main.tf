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

        for_each = var.transition_rules
        
        content {

            id = rule.value.id

            status = rule.value.status

            # dynamic "filter" {

            #     for_each = [rule.value.filter]

            #     content {

            #        and {
            #             prefix = try(filter.value.prefix, null)
            #             tags = try(filter.value.tags, null)
            #        } 
            #     }
              
            # }

            filter {}

            dynamic "transition" {

                for_each = rule.value.transition 

                content {
                    days = transition.value.days
                    storage_class = transition.value.storage_class
                  
                }
              
            }


            dynamic "expiration" {

                for_each = rule.value.expiration != null ? [rule.value.expiration]: []

                content {
                    expired_object_delete_marker = expiration.value.expired_object_delete_marker
                }
              
            }
          
        }

    }

    dynamic "rule" {

        for_each = var.non_current_transition_rule

        content {
          id = rule.value.id

          status = rule.value.status

        #   dynamic "filter" {

        #     for_each = [rule.value.filter]

        #     content {

        #         and {
        #             prefix = try(filter.value.prefix, null)
        #             tags = try(filter.value.tags, null)
                    
        #         }
              
        #     }
            
        #   }
        
        filter {}

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




