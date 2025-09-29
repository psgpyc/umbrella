{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action":  [
            "SQS:SendMessage",
            "SQS:DeleteMessage"
        ],
        "Principal": {
            "Service":  "sns.amazonaws.com"
        },
        "Resource": [
            "arn:aws:sqs:${Region}:${AccountId}:${QueueName}"
        ],
        "Condition": {
            "ArnLike": {
                "aws:SourceArn":  "${SourceSNSArn}"
            }
        }
    }] 

}