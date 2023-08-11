variable "vpc_cidr_block" {
    type = string
  
}

variable "instance_tenancy" {
    type = string
}

variable "tags" {
    type = map
  
}

variable "private_subnet_cidr_block" {
    type = list(string)
  
}

variable "private_subnet_availability_zone" {
    type = string
  
}

variable "map_public_ip_on_launch" {
    type = bool
  
}

variable "public_subnet_cidr_block" {
    type = list(string)
  
}

variable "public_subnet_availability_zone" {
    type = string
  
}

variable "public_ip_on_launch" {
    type = bool
  
}