module "UmbrellaRawBucket" {

    source = "./modules/s3"

    bucket_name = var.raw_bucket_name

    tags = var.raw_bucket_tags

    transition_rules = var.raw_bucket_transition_rules 

    non_current_transition_rule = var.raw_bucket_noncurrent_transition_rules
}

module "UmbrellaProcessedBucket" {

    source = "./modules/s3"

    bucket_name = var.processed_bucket_name

    tags = var.processed_bucket_tags

    transition_rules = var.processed_bucket_transition_rules

    non_current_transition_rule = var.processed_bucket_noncurrent_transition_rules

}

module "UmbrellaAnalyticsBucket" {

    source = "./modules/s3"

    bucket_name = var.analytics_bucket_name

    tags = var.analytics_bucket_tags

    transition_rules = var.analytics_bucket_transition_rules

    non_current_transition_rule = var.analytics_bucket_noncurrent_transition_rules
}




module "extractor_iam_role" {

    source = "./modules/iam"

    iam_role_name = "UmbrellaExtractorRole"

    assume_role_policy = templatefile("./policies/assume_role_policy.json.tpl", {
        assuming_resources = ["lambda.amazonaws.com"]
    })

    tags = {
      Type = "ExtractorRole"
    }

    policy_name = "UmbrellaExtractorRoleAllowPutS3Policy"

    policy = templatefile("./policies/iam_policy.json.tpl", {
        allowed_action_on_resource = ["s3:PutObject", "s3:ListBucket"]
        resources = ["${module.UmbrellaRawBucket.bucket_arn}", "${module.UmbrellaRawBucket.bucket_arn}/*"]
    })

     
  
}


module "transformer_iam_role" {

    source = "./modules/iam"

    iam_role_name = "UmbrellaTransformerRole"

    assume_role_policy = templatefile("./policies/assume_role_policy.json.tpl", {
        assuming_resources = ["glue.amazonaws.com"]
    })

    tags = {
      Type = "TransformerRole"
    }

    policy_name = "UmbrellaTransformerRoleAllowPutS3Policy"

    policy = templatefile("./policies/transformer_iam_role_policy.json.tpl", {
        raw_bucket_arn = module.UmbrellaRawBucket.bucket_arn
        transformer_bucket_arn = module.UmbrellaProcessedBucket.bucket_arn
    })
  
}



module "analytics_iam_role" {
    source = "./modules/iam"

    iam_role_name = "UmbrellaAnalyticsRole"

    assume_role_policy = templatefile("./policies/snowflake_assume_role_policy.json.tpl", {
        snowflake_arn = "arn:aws:iam::897729116490:root"
    })

    tags = {
      Type = "AnalyticsRole"
    }

    policy_name = "UmbrellaAnalyticsRolePolicy"

    policy = templatefile("./policies/snowflake_iam_role.json.tpl", {
        analytics_bucket_arn = module.UmbrellaAnalyticsBucket.bucket_arn
    })
}