module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true


  enable_irsa = true
  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    general = {
        desired_size = 1
        min_size = 1
        max_size = 10

        labels = {
            role = "general"
        }

        instance_types = ["t3.small"]
        capacity_type = "ON_DEMAND"
    }

    spot = {
        desired_size = 1
        min_size = 1
        max_size = 10

        labels = {
            role = "spot"
        }

        taints = [{
            key = "market"
            value = "spot"
            effect = "NO_SCHEDULE"
        }]

        instance_types = ["t3.micro"]
        capacity_type = "SPOT"
    }
  }


}