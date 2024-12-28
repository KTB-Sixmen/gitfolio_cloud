resource "aws_ecr_repository" "gitfolio" {
  name                   = "${ var.ecr_namespace_name }/${ var.ecr_repo_name[var.ecr_index] }"
  image_tag_mutability   = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "Gitfolio ${ var.ecr_repo_name[var.ecr_index] } ECR repository"
    Environment = terraform.workspace
  }
}

resource "aws_ecr_lifecycle_policy" "gitfolio_dev_lifecycle" {
  repository = aws_ecr_repository.gitfolio.name

  policy = jsonencode({
    rules = [
      {
        rulePriority   = 1
        description    = "Keep images created under a week"
        selection = {
          tagStatus    = var.policy_tagStatus
          countType    = var.policy_countType
          countNumber  = var.policy_countNum
          countUnit    = "days"
        }
        action = {
          type         = "expire"
        }
      }
    ]
  })
}