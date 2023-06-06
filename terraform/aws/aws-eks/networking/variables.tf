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

// VPC VARIABLES
variable "vpc_cidr_block" {
  type        = string
  description = "(Required) AWS VPC CIDR Block."
}

variable "enable_dns_support" {
  type        = bool
  description = "(Required) Enable DNS Support."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "(Required) Enable DNS Hostnames."
  default     = true
}

// NAT GATEWAY
variable "connectivity_type" {
  type        = string
  description = "(Required) Connectivity Type for NAT Gateway"
  default     = "public"
  validation {
    condition     = contains(["private", "public"], var.connectivity_type)
    error_message = "The current support values are private and public."
  }
}

// SUBNETS VARIABLES
variable "assign_public_ip" {
  type        = bool
  description = "(Required) Assigning a Public IP address."
  default     = true
}

// NUMBER OF PUBLIC SUBNETS SHOULD BE CREATED
variable "number_public_subnet" {
  description = "(Required) Number of public subnets."
  type        = number
  default     = 2
}

// NUMBER OF PRIVATE SUBNETS SHOULD BE CREATED
variable "number_private_subnet" {
  description = "(Required) Number of private subnets."
  type        = number
  default     = 2
}