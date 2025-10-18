module "VPC" {
  source = "./modules/VPC"
}

module "EKS" {
  source         = "./modules/EKS"
  public_subnets = module.VPC.public_subnets
}

module "nodegroup" {
  source            = "./modules/nodegroup"
  eks_cluster_name  = module.EKS.cluster_name
  private_subnets   = module.VPC.private_subnets
  vpc_id            = module.VPC.vpc_id
  eks_cluster_sg_id = module.EKS.cluster_sg_id
  depends_on        = [module.EKS]
}

module "helm" {
  source     = "./modules/helm"
  depends_on = [module.nodegroup]
}

module "pod_identity" {
  source       = "./modules/pod-identity"
  cluster_name = module.EKS.cluster_name
  depends_on   = [module.EKS]
}
