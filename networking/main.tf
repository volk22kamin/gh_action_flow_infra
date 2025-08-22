module "vpc" {
  source = "./modules/vpc"

  vpc_cidr                  = "10.0.0.0/16"
  enable_dns_support        = true
  enable_dns_hostnames      = true
  name                      = "secure-app-vpc"
  public_subnet_count       = var.public_subnet_count
  private_subnet_count      = var.private_subnet_count
  providers = {
    aws = aws.region_eu_central
  }
}

module "vpc_endpoints" {
    source = "./modules/vpc-endpoints"

    vpc_id              = module.vpc.vpc_id
    subnet_ids          = module.vpc.private_subnet_ids
    route_table_ids     = [module.vpc.private_route_table_id]
    vpc_endpoints = [
        # {
        #     service_name        = "com.amazonaws.${var.region}.s3"
        #     type                = "Gateway"
        #     tags                = { Name = "S3 Gateway Endpoint" }
        # },
        # {
        #     service_name        = "com.amazonaws.${var.region}.ecr.api"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "ECR API Endpoint" }
        # },
        # {
        #     service_name        = "com.amazonaws.${var.region}.ecr.dkr"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "ECR Docker Endpoint" }
        # },
        # {
        #     service_name        = "com.amazonaws.${var.region}.logs"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "CloudWatch Logs Endpoint" }
        # },
        {
            service_name        = "com.amazonaws.${var.region}.ssm"
            type                = "Interface"
            private_dns_enabled = true
            tags                = { Name = "SSM Endpoint" }
        },
        {
            service_name        = "com.amazonaws.${var.region}.ssmmessages"
            type                = "Interface"
            private_dns_enabled = true
            tags                = { Name = "SSM Messages Endpoint" }
        },
        {
            service_name        = "com.amazonaws.${var.region}.ec2messages"
            type                = "Interface"
            private_dns_enabled = true
            tags                = { Name = "EC2 Messages Endpoint" }
        },
        # {
        #     service_name        = "com.amazonaws.${var.region}.ecs"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "ECS Endpoint" }
        # },
        # {
        #     service_name        = "com.amazonaws.${var.region}.ecs-agent"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "ECS Agent Endpoint" }
        # },
        # {
        #     service_name        = "com.amazonaws.${var.region}.ecs-telemetry"
        #     type                = "Interface"
        #     private_dns_enabled = true
        #     tags                = { Name = "ECS Telemetry Endpoint" }
        # },
        {
          service_name        = "com.amazonaws.${var.region}.secretsmanager"
          type                = "Interface"
          private_dns_enabled = true
          tags                = { Name = "secretsmanager Endpoint" }
        }   
    ]
    vpc_cidr_block        = module.vpc.vpc_cidr
    default_tags          = var.default_tags
    providers = {
        aws = aws.region_eu_central
    }
}

module "endpoints_sg" {
    source = "./modules/sg"

    vpc_id = module.vpc.vpc_id
    default_tags = var.default_tags
    providers = {
        aws = aws.region_eu_central
    }
}

module "nacl" {
    source = "./modules/nacl"

    vpc_id                  = module.vpc.vpc_id
    public_subnet_ids       = module.vpc.public_subnet_ids
    private_subnet_cidrs    = module.vpc.private_subnet_cidrs
    default_tags            = var.default_tags
    providers = {
        aws = aws.region_eu_central
    }
}

module "vpc_flow_logs" {
  source                        = "./modules/vpc-flow-logs"

  name                          = "secure-app"
  vpc_id                        = module.vpc.vpc_id
  traffic_type                  = "ALL"
  cloudwatch_retention_in_days  = 1
  tags                          = var.default_tags

  providers = {
    aws = aws.region_eu_central
  }
}