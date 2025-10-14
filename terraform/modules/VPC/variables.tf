variable "subnets" {
  type = map(object({
    cidr : string
    az : string
    type : string
  }))
  default = {
    public_a  = { cidr = "10.0.1.0/24", az = "eu-west-2a", type = "public" }
    private_a = { cidr = "10.0.2.0/24", az = "eu-west-2a", type = "private" }
    public_b  = { cidr = "10.0.3.0/24", az = "eu-west-2b", type = "public" }
    private_b = { cidr = "10.0.4.0/24", az = "eu-west-2b", type = "private" }
  }
}

variable "public_subnet_tags" {
  type = map(string)
  default = {
    "kubernetes.io/cluster/eks-2048" = "shared"
    "kubernetes.io/role/elb"         = 1
  }
}

variable "private_subnet_tags" {
  type = map(string)
  default = {
    "kubernetes.io/cluster/eks-2048"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# variable "endpoints" {
#   type    = list(string)
#   default = ["com.amazonaws.eu-west-2.ecr.dkr", "com.amazonaws.eu-west-2.ecr.api"]
# }
