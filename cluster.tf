resource "aws_ecs_cluster" "m1_cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "m1_task_definition" {
  family                   = "${terraform.workspace}-m1-task-defination"
  requires_compatibilities = [var.launch_type]
  execution_role_arn       = aws_iam_role.m1_ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  memory                   = var.memory_cluster
  cpu                      = var.cpu_cluster
  container_definitions    = jsonencode([
    {
      name: "m1",
      image: "${data.aws_ecr_repository.m1_ecr_repository.repository_url}:${var.image_tag}",
      essential: true,
      environment: [
        {
          "name": "APP_ENV",
          "value": terraform.workspace
        },
        {
          "name": "AWS_REGION",
          "value": var.aws_region,
        },
        {
          "name": "LEGACY_ACCESS_KEY_ID",
          "value": data.aws_ssm_parameter.aws_access_key_id.value,
        },
        {          "name": "LEGACY_SECRET_ACCESS_KEY",
          "value": data.aws_ssm_parameter.aws_secret_key.value,
        },
        {
          "name": "DATABASE_URI",
          "value": data.aws_ssm_parameter.database_uri.value,
        },
        {
          "name": "COGNITO_POOL_ID",
          "value": data.aws_ssm_parameter.cognito_pool_id.value,
        },
        {
          "name": "STRIPE_SECRET_KEY",
          "value": data.aws_ssm_parameter.stripe_secret_key.value,
        },
        {
          "name": "STRIPE_WEBHOOKS_ENDPOINT_SECRET",
          "value": data.aws_ssm_parameter.stripe_webhooks_endpoint_secret.value,
        },
        {
          "name": "HTTP_PORT",
          "value": var.http_port,
        },
        {
          "name": "HTTP_HOST",
          "value": var.http_host,
        },
        {
          "name": "HTTP_TIMEOUT",
          "value": var.http_timeout,
        },
        {
          "name": "TZ",
          "value": var.timezone,
        },
      ],
      portMappings:[        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      memory: var.memory_cluster,
      cpu: var.cpu_cluster,
      logConfiguration: {
        logDriver: "awslogs",
        options: {
          "awslogs-group": aws_cloudwatch_log_group.m1_log_group.id,
          "awslogs-region": var.aws_region,
          "awslogs-stream-prefix": "${var.project_name}-${terraform.workspace}"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "m1_service" {
  name            = "${terraform.workspace}-m1-service"
  cluster         = aws_ecs_cluster.m1_cluster.id
  task_definition = aws_ecs_task_definition.m1_task_definition.arn
  launch_type     = var.launch_type
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.m1_lb_http_target_group.arn
    container_name   = data.aws_ecr_repository.m1_ecr_repository.name
    container_port   = 3000
  }

  network_configuration {
    subnets          = data.aws_subnet_ids.default_subnet.ids
    assign_public_ip = true
  }
}
