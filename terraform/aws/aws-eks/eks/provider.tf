// AWS PROVIDER CODE BLOCK
// aws configure --profile forgerock
// aws configure sso
provider "aws" {
  region  = var.region
  profile = var.profile
  /* assume_role {
    role_arn = "arn:aws:iam::600908795746:role/tf-acn-role"
  } */

  default_tags {
    tags = {
      "Project"   = "ForgeRock"
      "ManagedBy" = "Terraform"
      "CreatedBy" = timestamp()
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

// LOCAL VARIABLE TO CREATE NAME OF RESOURCE AND ENVIRONMENT PARAMETER
locals {
  naming_eks = join("-", ["eks", var.purpose, var.environment, format("%02d", var.number_of_sequence)])

  environments = {
    "lab" = "LAB"
  }

  environment = local.environments[var.environment]
}

// LOCAL VARIABLES TO CREATE NODE GROUP LABELS, DEFINY NUMBER OF NODES, INTANCE TYPE, AND CONFIGURE ON_DEMAND OR SPOT
locals {
  node_pool_labels = {
    type = "test-forgerock"
  }

  nodes_number = range(0, var.node_pool_max_size + 1)
  spot_kubernetes_label = {
    "intent"              = "apps"
    "aws.amazon.com/spot" = "true"
    "lifecycle"           = "Ec2Spot"
  }

  instance_type_per_environment = {
    lab    = var.instance_type_per_environment[*]
    shared = var.instance_type_per_environment[*]
    dev    = var.instance_type_per_environment[*]
    pre    = var.instance_type_per_environment[*]
    pro    = var.instance_type_per_environment[*]
  }

  types_per_environment = {
    #lab = "SPOT"
    lab = "ON_DEMAND"
  }

  capacity_type = local.types_per_environment[var.environment]

  tags_kubernets_spot_node_group = {
    "lifecycle"           = "Ec2Spot"
    "aws.amazon.com/spot" = "true"
    "intent"              = "apps"
  }

  tags_spot_node_group = {
    "k8s.io/cluster-autoscaler/node-template/label/intent"    = "apps"
    "k8s.io/cluster-autoscaler/${local.naming_eks}"           = "owned"
    "k8s.io/cluster-autoscaler/node-template/label/lifecycle" = "Ec2Spot"
  }
}

locals {
  no_verify_ssl = var.no_verify_ssl ? " --no-verify-ssl " : ""
}
