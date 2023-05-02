###############################################################################
# Local variables
###############################################################################
locals {
  standard_tags {
    product       = "ForgeRock"
    cost_center   = ""
    description   = ""
    environment   = var.environment
    geo_region    = ""
    app_name      = ""
    function      = ""
    sequence      = "001"
  }
}

###############################################################################
# EKS Cluster
###############################################################################
module "mbb_kubernetes_cluster" {
  source = ""

  vpc_id             = var.vpc_id
  kms_key_arn        = var.kms_key_arn
  node_subnet_ids    = var.subnets_ids
  security_group_ids = var.security_group_ids

  pod_subnets = var.pod_subnets

  ec2_ssh_key = var.ec2_ssh_key_name

  tags = local.standard_tags
}

module "kubernetes_cluster_setup" {
  source = ""

  default_ingress_tls_common_name = var.eks_cert_common_name
  prom_ingress_hostname           = var.prom_ingress_hostname
  cloud_provides                  = "aws"
  environment                     = local.current_environment

  kubernetes_dashboard_ingress_hostname = var.kubernetes_dashboard_ingress_hostname
  infra_suporte_url                     = var.infra_suporte_url
  grafana_hostname                      = var.grafana_hostname

  load_balancer_ip                   = var.eks_load_balancer_ip
  ingress_node_selector              = module.mbb_kubernetes_cluster.route_nodepool_labels
  kubernetes_dashboard_node_selector = module.mbb_kubernetes_cluster.infra_nodepool_labels

  bootstrap_secrets = {
    "default_ingress_tls_crt"            = "aW52YWxpZA=="
    "default_ingress_tls_key"            = "aW52YWxpZA=="
    "dynatrace_api_token"                = "aW52YWxpZA=="
    "dynatrace_paas_token"               = "aW52YWxpZA=="
    "kubernetes_dashboard_client_id"     = "aW52YWxpZA=="
    "kubernetes_dashboard_client_secret" = "aW52YWxpZA=="
  }

  depends_on = [module.mbb_kubernetes_cluster]
}
