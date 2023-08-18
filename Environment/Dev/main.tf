provider "aws" {
    region = "ap-northeast-2"
   # access_key = "AKIA3*********"
    #secret_key = "EXCuxD2rQ**************"
  
}

module "s3-bucket" {
    source = "../../module/s3/"
    bucket_name = ["bucket-1", "bucket-2", "bucket-3", "bucket-4"]
    tag = {
        name = "Dev-bucket"
        env = "Dev"
    }
    env = "dev"
  
}

module "iam-user" {
    source = "../../module/iam-user/"
    users_name = ["user-1", "user-2", "user-3", "user-4", "user-5", "user-6", "user-7", "user-8", "user-9", "user-10"]
    env = "Dev"
  
}

module "instance" {
    source = "../../module/ec2-instance/"
    type = {
        dev = "t2.micro"
        test = "t3.micro"
        prod = "t2.medium"
    }
    tag = "Dev"
    instance_count = "1"
  
}

module "vpc" {
    source = "../../module/vpc/"
    vpc_cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    project = "maaax"
    env = "dev"
    private_subnet_cidr_block = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
    map_public_ip_on_launch = "false"
    public_subnet_cidr_block = ["10.0.128.0/19", "10.0.160.0/19"]
    public_ip_on_launch = "true"
  
}

module "alb" {
    source = "../../module/loadbalancer"
    internal = true
    load_balancer_type = "application"
    subnet_id = module.vpc.public_subnet_id
    protocol = "HTTP"
    port = "80"
    target_group_name = "alb-target-group"
    vpc_id = module.vpc.vpc_id
    sg_name = "alb-sg"
    project = "maaax"
    env = "dev"
    instance_id = module.instance.instance_id
  
}