{
    "Version":  "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal" : {
            "Service": ${jsonencode(assuming_resources)}
        },
        "Action":  ["sts:AssumeRole"]

    }]
}