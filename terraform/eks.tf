module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  # create the module only when requested
  count = var.create_eks ? 1 : 0

  cluster_name    = var.eks_cluster_name
  # Do not set `cluster_version` explicitly so the module picks a provider-supported default.
  # If you want to force a specific Kubernetes version, set it here — but ensure the
  # version is supported in your AWS region/account before applying.

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

output "eks_cluster_endpoint" {
  value       = var.create_eks ? module.eks[0].cluster_endpoint : ""
  description = "EKS cluster endpoint (empty if create_eks=false)"
}

output "eks_cluster_name" {
  value       = var.create_eks ? module.eks[0].cluster_name : ""
  description = "EKS cluster name"
}
