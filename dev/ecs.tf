

resource "aws_ecs_cluster" "this" {
  name = "${local.prefix}-cluster"

  tags = {
    Name = "${local.prefix}-fargate-cluster"
  }
}