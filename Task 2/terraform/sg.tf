module "eks-cluster-sg" {
  source         = "./tf-module/security-group"
  sg-name        = "${local.env}-${local.project}-eks-cluster-sg"
  sg-description = "EKS Cluster security group"
  vpc_id         = local.vpc_id
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow pods to communicate with the cluster API Server"
      cidr_blocks = [local.subnet_cidr[0], local.subnet_cidr[1], local.subnet_cidr[2]]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = merge(map("Name", join("-", [local.env, local.project, "eks-cluster-sg"])), map("ResourceType", "SECURITYGROUP"), local.common_tags)
}

module "eks-worker-node-sg" {
  source         = "./tf-module/security-group"
  sg-name        = "${local.env}-${local.project}-eks-worker-node-sg"
  sg-description = "EKS worker node security group"
  vpc_id         = local.vpc_id
  ingress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Allow all"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = merge(map("Name", join("-", [local.env, local.project, "eks-worker-node-sg"])), map("ResourceType", "SECURITYGROUP"), local.common_tags)
}
