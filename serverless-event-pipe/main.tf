data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "s3" {

    source = "./modules/s3"

    bucket_name = var.bucket_name

    rules = var.rules
    
    non_current_rules = var.non_current_rules
}


module "sns" {

    source = "./modules/sns"

    sns_topic_name = var.sns_topic_name

    topic_resource_policy = templatefile("./policies/sns_resource_policy.json.tpl", {
        current_region = data.aws_region.current.id
        source_account_id = data.aws_caller_identity.current.account_id
        topic_name = var.sns_topic_name

    })

    tags = var.tags

    subscriptions = var.subscriptions
  
}

module "iam" {

    source = "./modules/iam"

    iam_role_name = var.iam_role_name

    assume_role_policy = file("./policies/lambda_execution_role.json")

    iam_role_policy = templatefile("./policies/lambda_execution_role_policy.json.tpl", {
        s3_bucket_arn = module.s3.bucket_arn,
        sns_topic_arn = module.sns.topic_arn

    })

}


module "lambda" {

    source = "./modules/lambda"

    source_dir = var.source_dir

    output_path = var.output_path

    lambda_iam_execution_role = module.iam.iam_role_arn

    lambda_func_name = var.lambda_func_name

    stage_name = var.stage_name

}
