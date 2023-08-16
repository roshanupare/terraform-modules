provider "aws" {
    region = "ap-northeast-2"
   # access_key = "AKIA3*********"
    #secret_key = "EXCuxD2rQ**************"
  
}

module "s3-bucket" {
    source = "../../module/s3/"
    bucket_name = ["shubham-s3", "ganesh-s3", "vishal-s3", "shankar-s3"]
    tag = {
        name = "Dev-bucket"
        env = "Dev"
    }
    env = "dev"
  
}

module "iam-user" {
    source = "../../module/iam-user/"
    users_name = ["shankar", "sahil", "ganesh", "harshit", "shubham", "vaibhav", "rupa", "vicky", "aafreen", "roshan"]
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
    instance_count = "5"
  
}

module "vpc" {
    source = "../../module/vpc/"
    vpc_cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    project = "maaax"
    env = "dev"
    private_subnet_availability_zone = "ap-northeast-2a"
    private_subnet_cidr_block = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
    map_public_ip_on_launch = "false"
    public_subnet_availability_zone = "ap-northeast-2b"
    public_subnet_cidr_block = ["10.0.128.0/19"]
    public_ip_on_launch = "true"
  
}