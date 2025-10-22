variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to provision on the bastion"
  type        = string
  default     = "my-laptop-key"
}

variable "allow_ssh_cidr" {
  description = "CIDR allowed to SSH to the bastion (your office/home IP)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial Postgres database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for RDS (will be stored in Secrets Manager)"
  type        = string
  default     = "appadmin"
}

variable "create_rds" {
  description = "Whether to create the RDS instance (set false for demo without infra costs)"
  type        = bool
  default     = true
}

variable "create_eks" {
  description = "Whether to create an EKS cluster (set false for local/minikube demos)"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  description = "Name for the EKS cluster (if create_eks = true)"
  type        = string
  default     = "knova-eks"
}

variable "eks_node_group_desired_capacity" {
  description = "Desired capacity for managed node group"
  type        = number
  default     = 1
}
