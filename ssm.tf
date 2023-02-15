locals {
  workspace = upper(terraform.workspace)
}

data "aws_ssm_parameter" "aws_access_key_id" {
  name = "/${local.workspace}/AWS_ACCESS_KEY_ID"
}

data "aws_ssm_parameter" "aws_secret_key" {
  name = "/${local.workspace}/AWS_SECRET_ACCESS_KEY"
}

data "aws_ssm_parameter" "database_uri" {
  name = "/${local.workspace}/DATABASE_URI"
}

data "aws_ssm_parameter" "cognito_pool_id" {
  name = "/${local.workspace}/COGNITO_POOL_ID"
}

data "aws_ssm_parameter" "stripe_secret" {
  name = "/${local.workspace}/STRIPE_SECRET"
}

data "aws_ssm_parameter" "stripe_secret_key" {
  name = "/${local.workspace}/STRIPE_SECRET_KEY"
}
