resource "aws_cloudwatch_log_group" "this" {
  name = "${local.prefix}-cloudwatch-log-group"

  tags = {
    Name        = "${local.prefix}-cloudwatch-log-group"
    Environment = var.stage
  }
}

resource "aws_cloudwatch_log_stream" "todo_container_cloudwatch_logstream" {
  name           = "${local.prefix}-cloudwatch-log-stream"
  log_group_name = aws_cloudwatch_log_group.this.name
}