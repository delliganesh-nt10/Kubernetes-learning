module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # REQUIRED for node group validation
  cluster_service_ipv4_cidr = "172.20.0.0/16"

  # REQUIRED so kubectl works from your laptop
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true


  tags = {
    Project = "flask-notes"
  }
}
