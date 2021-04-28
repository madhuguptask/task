module "eks-labs" {
  source                    = "./tf-module/eks/cluster"
  cluster_name              = local.eks_cluster_name
  subnet_ids_for_cluster    = [local.subnet[0], local.subnet[1], local.subnet[2]]
  security_group_ids        = [module.eks-cluster-sg.id]
  iam_role_arn              = module.eks-cluster-role.role-arn
  cluster-tags              = merge(map("Name", join("-", [local.env, local.project, "eks-cluster"])), map("ResourceType", "EKS"), local.common_tags)
  k8-version                = local.k8-version
  endpoint_private_access = true
  endpoint_public_access = false
}