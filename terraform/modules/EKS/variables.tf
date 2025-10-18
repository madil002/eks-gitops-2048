variable "public_subnets" {
  type = list(string)
}

variable "eks_addons" {
  type    = list(string)
  default = ["kube-proxy", "vpc-cni", "eks-pod-identity-agent"]
}
