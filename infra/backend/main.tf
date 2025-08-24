module "ecs_ec2_server" {
  source = "./modules/ecs-ec2-server"

  cluster_name          = var.cluster_name
  vpc_id                = var.vpc_id
  vpc_cidr              = data.aws_vpc.secure_app_vpc.cidr_block
  private_subnet_ids    = data.aws_subnets.private.ids
  instance_type         = var.instance_type
  key_name              = var.key_name
  volume_size           = var.volume_size
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  container_image       = var.container_image
  container_port        = var.container_port
  service_desired_count = var.service_desired_count
  service_min_count     = var.service_min_count
  service_max_count     = var.service_max_count
  service_cpu_target    = var.service_cpu_target
  ami_id                = var.ami_id
  log_retention_days    = var.log_retention_days
  target_group_arn      = module.ecs_api_alb.target_group_arn
  mongo_host            = var.mongo_host
  mongo_db              = var.mongo_db
  mongo_user            = var.mongo_user
  mongodb_secret_arn    = var.mongodb_secret_arn
}

module "ecs_api_alb" {
  source = "./modules/ecs-api-alb"

  alb_name               = var.alb_name
  vpc_id                 = var.vpc_id
  public_subnet_ids      = data.aws_subnets.public.ids
  container_port         = var.container_port
  ecs_security_group_id  = module.ecs_ec2_server.security_group_id
  health_check_path      = var.health_check_path
}