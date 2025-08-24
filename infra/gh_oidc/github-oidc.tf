# github-oidc.tf
#
# Terraform to set up GitHub Actions OIDC access to AWS (no long-lived keys).
# - Creates IAM OIDC provider for GitHub (token.actions.githubusercontent.com)
# - Creates an IAM role trusted by GitHub OIDC, locked to your repo + branch OR environment
# - Attaches a minimal policy for ECR push/pull, ECS deploy, S3 upload (client), and CloudFront invalidation
#
# Usage:
#   1) Set variables (see "Variables" below or provide via *.tfvars)
#   2) terraform init && terraform apply
#   3) Use the output "github_oidc_role_arn" in your GitHub Actions workflow with aws-actions/configure-aws-credentials

############################################################
# Data sources
############################################################

data "aws_caller_identity" "current" {}

############################################################
# Variables
############################################################

variable "github_owner" {
  description = "GitHub org/user that owns the repository"
  type        = string
  default     = "volk22kamin"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "gh_action_flow_infra"
}

variable "github_branch" {
  description = "Branch name to allow when not using environments (e.g., main)"
  type        = string
  default     = "main"
}

variable "github_environment" {
  description = "If set, trust policy locks to this GitHub Environment instead of a branch"
  type        = string
  default     = "dev"
}

variable "ecr_repo_name" {
  description = "ECR repository used for your backend image"
  type        = string
  default     = "secure-app-backend"
}

variable "aws_region" {
  description = "Region where your ECR repository lives"
  type        = string
  default     = "eu-central-1"
}

variable "client_bucket_name" {
  description = "S3 bucket where the static client (index.html) is uploaded"
  type        = string
  default     = "secure-app-client-eu-central-1"
}

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role your tasks use"
  type        = string
  default     = "dev-cluster-ecs-task-role"
}

variable "ecs_task_role_name" {
  description = "Name of the task role for your application task (if used)"
  type        = string
  default     = "dev-cluster-ecs-task-role"
}

variable "iam_role_name" {
  description = "Name for the IAM role assumed by GitHub Actions"
  type        = string
  default     = "github-actions-deploy"
}

############################################################
# Locals
############################################################

locals {
  gha_sub = (
    var.github_environment != null && var.github_environment != ""
    ? "repo:${var.github_owner}/${var.github_repo}:environment:${var.github_environment}"
    : "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
  )
}

############################################################
# GitHub OIDC Provider
############################################################

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

############################################################
# IAM Role trusted by GitHub OIDC
############################################################

data "aws_iam_policy_document" "gh_oidc_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.gha_sub]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.gh_oidc_trust.json
}

############################################################
# Permissions for the role
############################################################

locals {
  account_id              = data.aws_caller_identity.current.account_id
  ecr_repo_arn            = "arn:aws:ecr:${var.aws_region}:${local.account_id}:repository/${var.ecr_repo_name}"
  s3_client_bucket_arn    = "arn:aws:s3:::${var.client_bucket_name}"
  s3_client_objects_arn   = "arn:aws:s3:::${var.client_bucket_name}/*"
  task_execution_role_arn = "arn:aws:iam::${local.account_id}:role/${var.ecs_task_execution_role_name}"
  task_role_arn           = "arn:aws:iam::${local.account_id}:role/${var.ecs_task_role_name}"
}

data "aws_iam_policy_document" "github_permissions" {
  statement {
    sid     = "EcrAuth"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "EcrPull"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]
    resources = [local.ecr_repo_arn]
  }

  statement {
    sid    = "EcrPush"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:CreateRepository"
    ]
    resources = [local.ecr_repo_arn]
  }

  statement {
    sid    = "EcsDeploy"
    effect = "Allow"
    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:CreateService"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "PassExecutionAndTaskRoles"
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      local.task_execution_role_arn,
      local.task_role_arn
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }

  }

  statement {
    sid    = "S3ListClientBucket"
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [local.s3_client_bucket_arn]
  }

  statement {
    sid    = "S3UploadClient"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = [local.s3_client_objects_arn]
  }

  statement {
    sid       = "CloudFrontInvalidate"
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_permissions" {
  name        = "${var.iam_role_name}-policy"
  description = "Permissions for GitHub Actions"
  policy      = data.aws_iam_policy_document.github_permissions.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_permissions.arn
}

############################################################
# Outputs
############################################################

output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_oidc_role_arn" {
  value       = aws_iam_role.github_actions.arn
}

output "gha_expected_sub" {
  value       = local.gha_sub
}
