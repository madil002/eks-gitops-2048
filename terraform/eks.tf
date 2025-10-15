resource "aws_eks_cluster" "main" {
  name = "eks-2048"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.34"

  vpc_config {
    subnet_ids              = module.VPC.public_subnets
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.eks_cluster.id]
  }
}

resource "aws_eks_addon" "all" {
  count        = length(var.eks_addons)
  cluster_name = aws_eks_cluster.main.name
  addon_name   = var.eks_addons[count.index]
}

variable "eks_addons" {
  type    = list(string)
  default = ["kube-proxy", "vpc-cni"]
}

resource "aws_iam_role" "cluster" {
  name = "cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cluster.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = module.VPC.vpc_id

  ingress {
    description = "Allow worker nodes to communicate with cluster API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}