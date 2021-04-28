data "aws_iam_policy_document" "iam_role_policy_json" {
  statement {
    actions   = ["sts:AssumeRole"]
    principals {
      identifiers = var.service_identifers
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "iam_role" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.iam_role_policy_json.json
  tags = var.tags
}

resource "aws_iam_instance_profile" "iam-instances-profile" {
  name = var.role_name
  role = aws_iam_role.iam_role.name
}