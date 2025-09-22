resource "aws_iam_role" "this" {

    name = var.iam_role_name

    assume_role_policy = var.assume_role_policy

    tags = var.tags

}

resource "aws_iam_policy" "this" {

    name = var.policy_name

    policy = var.policy

  
}

resource "aws_iam_role_policy_attachment" "this" {

    role = aws_iam_role.this.id

    policy_arn = aws_iam_policy.this.arn
  
}