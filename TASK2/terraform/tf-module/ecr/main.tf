resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = var.tags
  lifecycle {
    prevent_destroy = true
  }
}