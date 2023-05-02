variable "eks_load_balancer_ip" {
  type = string
  description = "Fixed load balancer ip"
  default = null 
}

variable "vpc_id" {
  type = string
  description = "EKS VPC id"
}

variable "subnet_ids" {
  type = list(string)
  description = "List of subnet's for EKS"
}

variable "kms_key_arn"{
    type = string
    description = "KMS key ARN"
}

variable "security_group_ids" {
    type = list(string)
    description = "List of security group ids"
}

variable "pod_subnets" {
    description = "Subnet ID the cluster will run pods"
    type = list(object({
        subnet_id = string
        subnet_availability_zone_name = string
        security_group_id = string
    }))
}

variable "prom_ingress_hostname" {
    type = string
    description = "Hostname for prometheus dashboard"
}

variable "kubernetes_dashboard_ingress_hostname" {
    type = string
    description = "Kubernetes dashboard hostname. Must match the RedirectUri registered on the Azure AD application"
}

variable "eks_cert_common_name" {
    type = string
    description = "Common name for certificate"
}

variable "infra_suporte_url" {
    type = string
    description = "URL for AppDummyClient"
}

variable "grafana_hostname" {
    type = string
    description = "Grafana hostname"
}

variable "environment" {
    type = string
    description = "Environment"
}

variable "ec2_ssh_key_name" {
    type = string
    description = "EC2 SSH Key Pair name for remote connection on cluster nodes"
}