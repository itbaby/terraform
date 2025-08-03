resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.1.0.0/16"
  tags  = {
    Name    = "development-2"
  }

}


resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id 
  cidr_block = "10.1.10.0/24"
  availability_zone = "ap-northeast-1a"
  tags  = {
    Name    = "subnet-1-dev-2"
  }
}

# Create a subnet group for Elasticache
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "hello-world-redis-subnet-group-3"
  subnet_ids = [aws_subnet.dev-subnet-1.id]
  
  tags = {
    Name        = "Hello World Redis Subnet Group"
    Environment = "production"
    Project     = "hello-world"
  }
}

# Create security group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "hello-world-redis-sg-3"
  description = "Allow traffic to Redis cluster"
  vpc_id      = aws_vpc.dev-vpc.id
  
  # Allow inbound Redis traffic from application servers
  ingress {
    description = "Redis TCP"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"] # Updated to match VPC CIDR range
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "Hello World Redis Security Group"
    Environment = "production"
    Project     = "hello-world"
  }
}

# Fixed Elasticache Redis cluster with best practices
resource "aws_elasticache_cluster" "redis_hello" {
  cluster_id           = "hello-world-redis-3"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis7"
  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  
  # Backup configuration (best practice)
  snapshot_retention_limit = 7
  snapshot_window          = "03:00-04:00"
  
  # Maintenance window (best practice)
  maintenance_window = "Mon:04:00-Mon:05:00"
  
  # Note: Encryption requires Redis 6.2+ or specific configurations
  # transit_encryption_enabled = true
  
  # Tags (best practice)
  tags = {
    Name        = "Hello World Redis Cluster"
    Environment = "production"
    Project     = "hello-world"
    ManagedBy   = "terraform"
  }
}
