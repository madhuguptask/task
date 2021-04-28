module "eks-cluster-role" {
  source = "./tf-module/iam"
  role_name = "${local.env}-${local.project}-eks-cluster-role"
  service_identifers = ["eks.amazonaws.com"]
  tags = merge(map("Name", "${local.env}-${local.project}-eks-cluster-role"),map("ResourceType","IAM"),local.common_tags)
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = module.eks-cluster-role.role-name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-service-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = module.eks-cluster-role.role-name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-cnipolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = module.eks-cluster-role.role-name
}

module "eks-worker-role" {
  source = "./tf-module/iam"
  role_name = "${local.env}-${local.project}-eks-worker-role"
  service_identifers = ["ec2.amazonaws.com"]
  tags = merge(map("Name", "${local.env}-${local.project}-eks-worker-role"),map("ResourceType","IAM"),local.common_tags)
}

resource "aws_iam_role_policy_attachment" "eks-worker-role-nodeplicy" {
  role = module.eks-worker-role.role-name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "eks-worker-role-cnipolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = module.eks-worker-role.role-name
}
resource "aws_iam_role_policy_attachment" "eks-worker-role-servicepolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = module.eks-worker-role.role-name
}
resource "aws_iam_role_policy_attachment" "eks-worker-role-containerregistry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = module.eks-worker-role.role-name
}


