{
    "Version":  "2012-10-17",
    "Statement":  [{
        "Effect": "Allow",
        "Action": ${jsonencode(allowed_action_on_resource)},
        "Resource": ${jsonencode(resources)}

    }]
}