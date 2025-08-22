module "mongo_ec2" {
  source              = "./modules/mongo-ec2"
  mongo_ami_id        = var.mongo_ami_id
  instance_type       = var.instance_type
  vpc_id              = var.vpc_id
  private_subnet_id   = data.aws_subnets.private.ids[0]
  ecs_service_sg_id   = var.ecs_service_sg_id
}
