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

// AWS PROFILE CONFIGURED USING AWS CLI (aws configure --profile <profile-name>)
variable "profile" {
  description = "(Required) AWS Profile for Account."
  type        = string
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

// SECURITY
variable "enable_key_rotation" {
  description = "(Required) Enable key rotation for AWS CMK."
  type        = string
  default     = false
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