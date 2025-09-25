{
    "Version":  "2012-10-17",
    "Statement":  [{
        "Effect": "Allow",
        "Action": [
            "SNS:Publish"
        ],
        "Principal":  {
            "Service": "${service}"
        },
        "Resource": [
            "arn:aws:sns:${current_region}:${source_account_id}:${topic_name}"
        ]
    }]
}