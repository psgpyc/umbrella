module "UmbrellaRawBucket" {

    source = "./modules/s3"

    bucket_name = "umbrella-raw"
  
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