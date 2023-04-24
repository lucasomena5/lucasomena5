variable "region" {
  type = string
  default = "us-east-1"
}

variable "profile" {
  type = string 
  default = "lab-aws"
}

variable "cidr_block" {
  type = string 
  default = "10.0.0.0/16"
}
