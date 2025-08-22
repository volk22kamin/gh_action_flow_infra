module "ecs_ec2_server" {
  source = "./modules/ecs-ec2-server"

  cluster_name              = var.cluster_name
  enable_container_insights = var.enable_container_insights
  log_retention_days        = var.log_retention_days
}

