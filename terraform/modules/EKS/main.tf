resource "aws_eks_cluster" "main" {
  name = "eks-2048"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.34"

  vpc_config {
    subnet_ids              = var.public_subnets
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
  }
}

resource "aws_eks_addon" "all" {
  count        = length(var.eks_addons)
  cluster_name = aws_eks_cluster.main.name
  addon_name   = var.eks_addons[count.index]
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

resource "aws_security_group_rule" "node_to_cluster" {
  type                     = "ingress"
  to_port                  = "443"
  from_port                = "443"
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.eks_node_sg_id
}
