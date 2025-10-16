module "VPC" {
  source = "./modules/VPC"
}

module "EKS" {
  source         = "./modules/EKS"
  public_subnets = module.VPC.public_subnets
  eks_node_sg_id = module.nodegroup.eks_node_sg_id
}

module "nodegroup" {
  source            = "./modules/nodegroup"
  eks_cluster_name  = module.EKS.cluster_name
  private_subnets   = module.VPC.private_subnets
  vpc_id            = module.VPC.vpc_id
  eks_cluster_sg_id = module.EKS.cluster_sg_id
}

module "helm" {
  source = "./modules/helm"
}

module "pod_identity" {
  source       = "./modules/pod-identity"
  cluster_name = module.EKS.cluster_name
  depends_on   = [module.helm]
}
