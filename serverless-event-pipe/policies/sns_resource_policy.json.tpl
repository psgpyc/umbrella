{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect":  "Allow",
        "Principal":  {
            "Service":  "s3.amazonaws.com"
        },
        "Action" : [
            "sns:Publish"
        ],
        "Resource": [
            "arn:aws:sns:${current_region}:${source_account_id}:${topic_name}"
        ]
    }]
}