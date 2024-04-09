
// Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
  tags = {
    Name = "Main VPC"
  }
}

// Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_1
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "public_subnet"
  }
}

// Almost private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_2
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone


  tags = {
    Name = "private_subnet"
  }
}

// Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "route_table"
  }
}

// Default Route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

// Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet_gateway"
  }
}

// Route table association for public subnet
resource "aws_route_table_association" "route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}

// Route table association for private subnet
resource "aws_route_table_association" "route_table2" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.main.id
}