module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  subnet_ids      = module.vpc.private_subnets

 cluster_service_ipv4_cidr = "172.20.0.0/16"
  name = "flask-notes-ng"

  instance_types = ["t3.small"]

  min_size     = 1
  max_size     = 2
  desired_size = 1
}
