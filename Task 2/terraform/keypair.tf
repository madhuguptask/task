module "eks-node-key" {
  source     = "./tf-module/keypair"
  key_name   = "${local.env}-${local.project}-eks-node-keypair"
  public_key = local.labs-eks-node-key
  tags       = merge(map("Name", "${local.env}-${local.project}-eks-node-keypair"), map("ResourceType", "KEYPAIR"), local.common_tags)
}