resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "main" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-igw" }
}

resource "aws_subnet" "all" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = { Name = each.key }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private_rt" }
}

resource "aws_route_table_association" "all" {
  for_each = var.subnets

  subnet_id      = aws_subnet.all[each.key].id
  route_table_id = each.value.type == "public" ? aws_route_table.public.id : aws_route_table.private.id
}

# resource "aws_vpc_endpoint" "ec2" {
#   count             = length(var.endpoints)
#   vpc_id            = aws_vpc.main.id
#   service_name      = var.endpoints[count.index]
#   vpc_endpoint_type = "Interface"

#   subnet_ids         = [for key, subnet in aws_subnet.all : subnet.id if var.subnets[key].type == "private"]
#   security_group_ids = []

#   private_dns_enabled = true
# }

resource "aws_security_group" "endpoint" {
  name        = "endpoint"
  description = "SG for VPC Endpoint ENI"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
