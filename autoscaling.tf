resource "aws_appautoscaling_target" "m1_ecs_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.m1_cluster.name}/${aws_ecs_service.m1_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${terraform.workspace}-${var.project_name}-memory-autoscaling"
  policy_type        = var.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.m1_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.m1_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.m1_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.max_capacity_usage
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${terraform.workspace}-${var.project_name}-cpu-autoscaling"
  policy_type        = var.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.m1_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.m1_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.m1_ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.max_capacity_usage
  }
}
