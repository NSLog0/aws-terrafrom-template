data "aws_iam_policy_document" "m1_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "m1_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "sqs:SendMessage"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "m1_ecs_task_execution_role" {
  name               = "${terraform.workspace}-m1-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.m1_assume_role_policy.json
}

resource "aws_iam_role_policy" "m1_ecs_task_execution_role_policy" {
  name   = "${terraform.workspace}-m1-ecs-task-execution-role-policy"
  policy = data.aws_iam_policy_document.m1_policy_doc.json
  role   = aws_iam_role.m1_ecs_task_execution_role.id
}
