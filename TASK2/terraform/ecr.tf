module "ecr" {
  source = "./tf-module/ecr"
  repository_name = "${local.env}-${local.project}-ecr"
  tags = merge(map("Name", join("-", [local.env, local.project, "ecr"])), map("ResourceType", "ECR"), local.common_tags)
}
