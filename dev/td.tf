resource "aws_ecs_task_definition" "this" {
  family                   = "${local.prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.lab_role_arn
  task_role_arn            = local.lab_role_arn
  container_definitions = jsonencode([{
    name      = "${local.prefix}-container"
    image     = local.ecr_repo
    essential = true
    environment = [
      { "name" : "REGION", "value" : local.region },
      { "name" : "DBPORT", "value" : "80" },
      { "name" : "DBHOST", "value" : "localhost" }
    ]
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = local.log_group
        awslogs-stream-prefix = "/aws/ecs"
        awslogs-region        = local.region
      }
    }
  }])

  tags = {
    Name        = "${local.prefix}-task"
    Environment = var.stage
  }
}