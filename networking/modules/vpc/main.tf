resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-rt"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}