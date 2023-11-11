provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAV47KEOYMTZN2SAXT"
  secret_key = "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"
}


module "network_configuration" {
  source = "../modules/network"
  
}

module "RDS" {
  source = "../modules/RDS"
  
}

module "ecr" {
  source = "./modules/ECR"
  
}

module "lb" {
  source = "./modules/Lb"
  
}

module "ecs" {
  source = "../modules/ECS"
  
}

module "as" {
  source = "./modules/as"
  
}

module "CloudWatch" {
  source = "./modules/cloudwatch"
  
}


