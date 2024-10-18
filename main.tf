resource "aws_vpc" "ECG-Ghana" {
  cidr_block = var.vpc_cidr

  tags = var.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ECG-Ghana.id

  tags = var.tags
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.ECG-Ghana.id
  cidr_block        = var.public_subnet_cidrs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.ECG-Ghana.id
  cidr_block        = var.public_subnet_cidrs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.ECG-Ghana.id
  cidr_block = var.private_subnet_cidrs[0]

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.ECG-Ghana.id
  cidr_block = var.private_subnet_cidrs[1]

  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "NAT Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ECG-Ghana.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ECG-Ghana.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow access to private subnets"
  vpc_id      = aws_vpc.ECG-Ghana.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "private1" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private1.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "Private Instance 1"
  }
}

resource "aws_instance" "private2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private2.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "Private Instance 2"
  }
}

output "vpc_id" {
  value = aws_vpc.ECG-Ghana.id
}

output "public_subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnets" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "private_instances" {
  value = [aws_instance.private1.id, aws_instance.private2.id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
