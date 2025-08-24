module "ecs_to_mongo_sg" {
	source       = "./modules/sg"
	cluster_name = var.cluster_name
	vpc_cidr     = var.vpc_cidr
	vpc_id       = var.vpc_id
}
