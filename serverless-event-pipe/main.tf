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

module "sqs_dlq" {

    source = "./modules/sqs"

    sqs_queue_name = var.sqs_dlq_name

    tags = {
      Type = "dlq"
    }

}

module "sqs" {

    source = "./modules/sqs"

    sqs_queue_name = var.sqs_queue_name

    delay_seconds = var.delay_seconds
    receive_wait_time_seconds = var.receive_wait_time_seconds
    message_retention_seconds = var.message_retention_seconds

    sqs_resource_access_policy = templatefile("./policies/sqs_resource_access_policy.json.tpl", {
        region = data.aws_region.current.id
        account_id = data.aws_caller_identity.current.account_id
        queue_name = var.sqs_queue_name
    })

    # redrive_policy = templatefile("./policies/sqs_redrive_policy.json.tpl", {
    #     queue_arn = module.sqs_dlq.queue_arn
    #     max_receive_count     = 4
    # })

   

    depends_on = [ module.sqs_dlq ]
}

module "lambda" {

    source = "./modules/lambda"

    source_dir = var.source_dir

    output_path = var.output_path

    lambda_iam_execution_role = module.iam.iam_role_arn

    lambda_func_name = var.lambda_func_name

    stage_name = var.stage_name

}
