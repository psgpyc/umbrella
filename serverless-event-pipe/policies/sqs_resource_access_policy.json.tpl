{
    "Version":  "2012-10-17",
    "Statement": [{
        "Effect":  "Allow",
        "Action": [
            "sqs:SendMessage",
            "sqs:SendMessageBatch"
        ],
        "Principal": {
            "Service":  "sns.amazonaws.com"
        },
        "Resource":  [
            "arn:aws:sqs:${region}:${account_id}:${queue_name}"
        ]
    
    }]




}