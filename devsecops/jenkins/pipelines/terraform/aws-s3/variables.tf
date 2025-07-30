// AWS ACCOUNT
variable "region" {
  type        = string
  description = "(Required) AWS Region"
  default     = "us-east-1"
  # validation {
  #   condition     = contains(["us-west-1"], var.region)
  #   error_message = "The current support value is us-west-1."
  # }
}

variable "access_key" {
  description = "(Required) AWS Access Key for Account."
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "(Required) AWS Secret Key for Account."
  type        = string
  default     = ""
}