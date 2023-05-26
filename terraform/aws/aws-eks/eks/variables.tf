// AWS ACCOUNT
variable "region" {
  type        = string
  description = "(Required) AWS Region"
  default     = "us-east-1"
  validation {
    condition     = contains(["us-east-1"], var.region)
    error_message = "The current support value is us-east-1."
  }
}

// SECURITY
variable "enable_key_rotation" {
  description = "(Required) Enable key rotation for AWS CMK."
  type        = string
  default     = false
}

// AWS PROFILE CONFIGURED USING AWS CLI (aws configure --profile <profile-name>)
variable "profile" {
  description = "(Required) AWS Profile for Account."
  type        = string
}

// K8S VERSION 
variable "kubernetes_version" {
  description = "(Required) Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. "
  type        = string
  default     = "1.21"
}

// NODE POOL CONFIGURATIONS
variable "node_pool_desired_size" {
  description = "(Required) How many nodes on the node pool will have."
  type        = number
  default     = 2
}

// AUTOSCALING AND NODES VARIABLES
variable "node_pool_min_size" {
  description = "(Required) Minimum number of nodes on the node pool will have."
  type        = number
  default     = 1
}

variable "node_pool_max_size" {
  description = "(Required) Maximum number of nodes on the node pool will have."
  type        = number
  default     = 2
}

variable "disk_size_node" {
  description = "(Optional) Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided. "
  type        = number
  default     = 20
}

variable "ami_type" {
  description = "(Optional) Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64. Terraform will only perform drift detection if a configuration value is provided."
  type        = string
  default     = "AL2_x86_64"
}

variable "ec2_ssh_key" {
  description = "(Required) EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group. If you specify this configuration, but do not specify source_security_group_ids when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)."
  type        = string
}

variable "instance_type_per_environment" {
  description = "Instance types of ec2 per environment"
  type        = list(string)
}

// TAGGING NAME VARIABLES
variable "environment" {
  description = "(Required) Test environment used for Naming. (3 characters). i.e. lab, dev, pre, and pro"
  type        = string
}

variable "purpose" {
  description = "(Required) Test purpose used for Naming. (3 characters)."
  type        = string
}

variable "number_of_sequence" {
  description = "(Required) number_of_sequence number of the resource used for Naming. (2 characters)"
  type        = number
}

variable "vpc_cidr_block" {
  type        = string
  description = "(Required) AWS VPC CIDR Block."
}

variable "allowed_ports" {
  description = "(Required) Ports allowed to security group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = null
}

variable "no_verify_ssl" {
  description = "Set no_verify_ssl parameter on aws cli."
  type        = bool
  default     = false
}