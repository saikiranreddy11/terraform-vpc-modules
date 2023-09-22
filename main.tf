resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  
  tags = merge(var.common_tags,
                var.vpc_tags)
}


resource "aws_subnet" "public" {
    count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags,
                {
                    "Name" = "public_subnet_${var.azs[count.index]}"
                })
}

resource "aws_subnet" "private" {
    count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags,
                {
                    "Name" = "private_subnet_${var.azs[count.index]}"
                })
}

resource "aws_subnet" "db_subnet" {
    count = length(var.db_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_cidr_block[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.common_tags,
                {
                    "Name" = "db_subnet_${var.azs[count.index]}"
                })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,
                {
                    "Name" = "Roboshop"
                })
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
    #count = length(var.public_route)
#   route {
#     cidr_block = var.public_route
#     gateway_id = aws_internet_gateway.gw.id
#   }

   tags = merge(var.common_tags,
                {
                    "Name" = "Roboshop-public"
                })
}

resource "aws_route" "public_routes" {
    count = length(var.routes)
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.routes[count.index]
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_subnet_association" {
     count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
#the below code can also be used to associate the subnets , element function is used
# resource "aws_route_table_association" "public_subnet_association" {
#      count = length(var.public_cidr_block)
#   subnet_id      = element(aws_subnet.public[*].id,count.index)
#   route_table_id = aws_route_table.public.id

# }

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
    #count = length(var.public_route)
#   route {
#     cidr_block = var.public_route
#     gateway_id = aws_internet_gateway.gw.id
#   }

   tags = merge(var.common_tags,
                {
                    "Name" = "Roboshop-private"
                })
}


resource "aws_route_table_association" "private_subnet_association" {
     count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
    #count = length(var.public_route)
#   route {
#     cidr_block = var.public_route
#     gateway_id = aws_internet_gateway.gw.id
#   }

   tags = merge(var.common_tags,
                {
                    "Name" = "Roboshop-database"
                })
}

resource "aws_route_table_association" "db_subnet_association" {
     count = length(var.db_cidr_block)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.database.id
}