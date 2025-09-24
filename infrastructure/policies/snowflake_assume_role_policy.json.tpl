{
    "Version": "2012-10-17",
    "Statement":  [{
        "Effect": "Allow",
        "Principal":  {
            "AWS": "${snowflake_arn}"
        },
        "Action": "sts:AssumeRole"
    }]
}