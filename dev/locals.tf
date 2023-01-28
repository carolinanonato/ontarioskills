data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_role" "labrole" {
  name = "LabRole"
}

locals {
  prefix       = "${var.name}-${var.stage}"
  region       = data.aws_region.current.name
  ecr_repo     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-repo"
  log_group    = aws_cloudwatch_log_group.this.name
  lab_role_arn = data.aws_iam_role.labrole.arn
}