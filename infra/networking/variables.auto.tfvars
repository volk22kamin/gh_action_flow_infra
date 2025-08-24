public_subnet_count = 2
private_subnet_count = 2
region = "eu-central-1"
vpc_endpoints = [
  {
    service_name   = "com.amazonaws.eu-central-1.s3"
    route_table_ids = []
  },
  {
    service_name   = "com.amazonaws.eu-central-1.dynamodb"
    route_table_ids = []
  }
]
default_tags = {
  Environment = "dev"
  Project     = "secure-app"
  ManagedBy   = "Terraform"
}
