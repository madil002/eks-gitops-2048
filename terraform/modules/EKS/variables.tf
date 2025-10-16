variable "public_subnets" {
  type = list(string)
}

variable "eks_addons" {
  type    = list(string)
  default = ["kube-proxy", "vpc-cni"]
}

variable "eks_node_sg_id" {
  type = string
}
