resource "aws_cloudwatch_log_group" "m1_log_group" {
  name = "/ecs/cluster/${terraform.workspace}-${var.project_name}"
}
