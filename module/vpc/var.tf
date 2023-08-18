variable "vpc_cidr_block" {
    type = string
  
}

variable "instance_tenancy" {
    type = string
}

variable "env" {
    type = string
  
}

variable "project" {
    type = string
  
}

variable "private_subnet_cidr_block" {
    type = list(string)
  
}



variable "map_public_ip_on_launch" {
    type = bool
  
}

variable "public_subnet_cidr_block" {
    type = list(string)
  
}

variable "public_ip_on_launch" {
    type = bool
  
}