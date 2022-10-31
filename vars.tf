variable "VPC_CIDR" {
    type = string
    default = "10.0.0.0/16"
}

variable "VPC_PUBLIC_SUBNET_CIDR" {
    type = string
    default = "10.0.1.0/24"
  
}

variable "VPC_PRIVATE_SUBNET_CIDR" {
    type = string
    default = "10.0.2.0/24"
  
}

variable "AWS_REGION" {
    type = string
    default = "us-east-1"
  
}

variable "AWS_AZ" {
    type = string
    default = "us-east-1a"
  
}