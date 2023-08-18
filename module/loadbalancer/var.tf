variable "internal" {
  type = bool
}

variable "load_balancer_type" {
  type = string
}

variable "subnet_id" {
  type = any
}
variable "protocol" {
  type = any
}
variable "port" {
  type = number
}
variable "target_group_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "sg_name" {
  type = string
}
variable "project" {
    type = string
  
}
variable "env" {
  type = string
}
variable "instance_id" {
  type = any
}