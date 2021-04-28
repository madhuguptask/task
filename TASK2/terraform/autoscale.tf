module "eks-worker-asg" {
  source = "./tf-module/autoscale"
  desired_capacity = local.desired_capacity
  launch_template = module.labs-lt.id
  max_size = local.max_size
  min_size = local.min_size
  asg_mixed_instance_types = local.asg_mixed_instance_types
  spot_allocation_strategy = local.spot_allocation_strategy
  spot_instance_pools = local.spot_instance_pools
  name = "${local.env}-${local.project}-eks-worker-asg"
  vpc_zone_identifier = [local.subnet[0], local.subnet[1], local.subnet[2]]
  on_demand_percentage_above_base_capacity = local.on_demand_percentage_above_base_capacity
  scale-up-policy = local.scale-up-policy
  scale-down-policy = local.scale-down-policy
  tags = [
    {
      key                 = "Environment"
      value               = local.env
      propagate_at_launch = false
    },
    {
      key                 = "Owner"
      value               = local.developer
      propagate_at_launch = false
    },
    {
      key                 = "Cost-Center"
      value               = local.cost-center
      propagate_at_launch = false
    },
    {
      key                 = "Project"
      value               = local.project
      propagate_at_launch = false
    },
    {
      key                 = "k8s.io/cluster-autoscaler/${local.env}-${local.project}-eks-cluster"
      value               = "owned"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "true"
      propagate_at_launch = true
    }
  ]
}