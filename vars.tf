variable "AWS_REGION" {
    type = string
    default = "us-east-1"
  
}

variable "AWS_AZ" {
    type = string
    default = "us-east-1a"
  
}

variable "AMI_ID" {
    type = string
    default = "ami-09d3b3274b6c5d4aa"
  
}

variable "INSTANCE_TYPE" {
    type = string
    default = "t2.micro"
  
}
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

variable "SG_PORTS" {
    type = list(string)
    default = [ 22,80,443,8065 ]
  
}