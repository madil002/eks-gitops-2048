resource "aws_eks_node_group" "main" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  instance_types = ["t3.medium"]
  ami_type       = "AL2023_x86_64_STANDARD"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "1"
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix            = "eks-nodes-"
  vpc_security_group_ids = [aws_security_group.eks_node.id]

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
}

resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_policies" {
  count      = length(var.node_group_policies)
  role       = aws_iam_role.eks_node_group.id
  policy_arn = var.node_group_policies[count.index]
}

resource "aws_iam_role_policy" "pod_identity_agent" {
  name = "AmazonEKS_PodIdentityAgentPolicy"
  role = aws_iam_role.eks_node_group.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks-auth:AssumePodIdentityRole",
          "eks-auth:AuthenticatePodIdentity"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_security_group" "eks_node" {
  name        = "eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow node-to-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow cluster-to-node communication"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.eks_cluster_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
