{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect" : "Allow",
        "Action":  [
            "s3:GetObject", 
            "s3:ListBucket"
        ],
        "Resource":  [
            "${raw_bucket_arn}",
            "${raw_bucket_arn}/*"
        ]

    
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:PutObject"
        ],
        "Resource" : [
            "${transformer_bucket_arn}",
            "${transformer_bucket_arn}/*"
        ]
    }
]

}