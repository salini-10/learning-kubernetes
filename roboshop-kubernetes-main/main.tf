module "VPC" {
  source               = "github.com/raghudevopsb65/tf-module-vpc"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  VPC_CIDR             = var.VPC_CIDR
  PUBLIC_SUBNETS_CIDR  = var.PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR = var.PRIVATE_SUBNETS_CIDR
  AZ                   = var.AZ
  DEFAULT_VPC_ID       = var.DEFAULT_VPC_ID
  DEFAULT_VPC_CIDR     = var.DEFAULT_VPC_CIDR
  DEFAULT_VPC_RT       = var.DEFAULT_VPC_RT
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PUBLIC_ZONE_ID       = var.PUBLIC_ZONE_ID
}

module "RDS" {
  source             = "github.com/raghudevopsb65/tf-module-rds"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  ENGINE             = var.RDS_ENGINE
  ENGINE_VERSION     = var.RDS_ENGINE_VERSION
  RDS_INSTANCE_CLASS = var.RDS_INSTANCE_CLASS
  PG_FAMILY          = var.RDS_PG_FAMILY
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  RDS_PORT           = var.RDS_PORT
  ALLOW_SG_CIDR      = concat(module.VPC.PRIVATE_SUBNET_CIDR, tolist([var.WORKSTATION_IP]))
}

module "DOCDB" {
  source             = "github.com/raghudevopsb65/tf-module-docdb"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  ENGINE             = var.DOCDB_ENGINE
  ENGINE_VERSION     = var.DOCDB_ENGINE_VERSION
  INSTANCE_CLASS     = var.DOCDB_INSTANCE_CLASS
  PG_FAMILY          = var.DOCDB_PG_FAMILY
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.DOCDB_PORT
  ALLOW_SG_CIDR      = concat(module.VPC.PRIVATE_SUBNET_CIDR, tolist([var.WORKSTATION_IP]))
  NUMBER_OF_NODES    = var.DOCDB_NUMBER_OF_NODES
}

module "ELASTICACHE" {
  source             = "github.com/raghudevopsb65/tf-module-elasticache"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  ENGINE             = var.ELASTICACHE_ENGINE
  ENGINE_VERSION     = var.ELASTICACHE_ENGINE_VERSION
  INSTANCE_CLASS     = var.ELASTICACHE_INSTANCE_CLASS
  PG_FAMILY          = var.ELASTICACHE_PG_FAMILY
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.ELASTICACHE_PORT
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  NUMBER_OF_NODES    = var.ELASTICACHE_NUMBER_OF_NODES
}

module "RABBITMQ" {
  source             = "github.com/raghudevopsb65/tf-module-rabbitmq"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.RABBITMQ_PORT
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  INSTANCE_TYPE      = var.RABBITMQ_INSTANCE_TYPE
  WORKSTATION_IP     = var.WORKSTATION_IP
  PRIVATE_ZONE_ID    = var.PRIVATE_ZONE_ID
}

module "EKS" {
  source                  = "github.com/r-devops/tf-module-eks.git"
  ENV                     = var.ENV
  PRIVATE_SUBNET_IDS      = module.VPC.PRIVATE_SUBNET_IDS
  PUBLIC_SUBNET_IDS       = module.VPC.PUBLIC_SUBNET_IDS
  DESIRED_SIZE            = 2
  MAX_SIZE                = 4
  MIN_SIZE                = 2
  CREATE_ALB_INGRESS      = true
  CREATE_EXTERNAL_SECRETS = true
}
