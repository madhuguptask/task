data "aws_ssm_parameter" "eks-ami-18" {
  name = "/aws/service/eks/optimized-ami/1.18/amazon-linux-2/recommended/image_id"
}

module "labs-lt" {
  source = "./tf-module/launch_template"
  lt_name = "${local.env}-${local.project}-eks-worker-lt"
  iam_instance_profile = module.eks-worker-role.instances-profile
  image_id = data.aws_ssm_parameter.eks-ami-18.value
  instance_type = local.eks-worker-node-instance-type
  key_name = module.eks-node-key.key_name
  vpc_security_group_ids = [module.eks-worker-node-sg.id]
  user_data = local.eks-worker-node-userdata
  tags = merge(map("Name","${local.env}-${local.project}-lt"), map("ResourceType","LAUNCHTEMPLATE"), local.common_tags)
  instance_tags = merge(map("Name","${local.env}-${local.project}-eks-worker-node"), map("ResourceType","EC2"), local.common_tags, map("k8s.io/cluster-autoscaler/${local.env}-${local.project}-eks-cluster","owned"), map("kubernetes.io/cluster/${local.env}-${local.project}-eks-cluster","owned"))
  volume_tags = merge(map("Name","${local.env}-${local.project}-eks-worker-node"), map("ResourceType","EBS"), local.common_tags)
}
