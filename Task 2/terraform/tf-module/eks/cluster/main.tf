resource "aws_eks_cluster" "eks" {
  name = var.cluster_name
  vpc_config {
    subnet_ids              = var.subnet_ids_for_cluster
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access = var.endpoint_public_access
  }
  enabled_cluster_log_types = var.enabled_cluster_log_types
  role_arn                = var.iam_role_arn
  version                 = var.k8-version
  tags                    = var.cluster-tags
  lifecycle {
    prevent_destroy = true
  }
}