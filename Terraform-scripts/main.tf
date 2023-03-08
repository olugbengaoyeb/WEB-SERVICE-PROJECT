# VPC
resource "aws_vpc" "olugbenga_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "olugbenga-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "olugbenga_igw" {
  vpc_id = aws_vpc.olugbenga_vpc.id
  tags = {
    Name = "olugbenga-igw"
  }
}

# Public Subnet
resource "aws_subnet" "olugbenga_public_subnet" {
  vpc_id            = aws_vpc.olugbenga_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name = "olugbenga-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "olugbenga_private_subnet" {
  vpc_id            = aws_vpc.olugbenga_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name = "olugbenga-private-subnet"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "olugbenga_nat_gateway" {
  allocation_id = aws_eip.olugbenga_eip.id
  subnet_id     = aws_subnet.olugbenga_public_subnet.id
  tags = {
    Name = "olugbenga-nat-gateway"
  }
}

# Elastic IP
resource "aws_eip" "olugbenga_eip" {
  vpc = true
}

# Route Table
resource "aws_route_table" "olugbenga_route_table" {
  vpc_id = aws_vpc.olugbenga_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.olugbenga_nat_gateway.id
  }
  tags = {
    Name = "olugbenga-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "olugbenga_route_table_association_public" {
  subnet_id      = aws_subnet.olugbenga_public_subnet.id
  route_table_id = aws_route_table.olugbenga_route_table.id
}

resource "aws_route_table_association" "olugbenga_route_table_association_private" {
  subnet_id      = aws_subnet.olugbenga_private_subnet.id
  route_table_id = aws_route_table.olugbenga_route_table.id
}

# Security Group
resource "aws_security_group" "olugbenga_security_group" {
  name_prefix = "olugbenga-security-group"
  vpc_id      = aws_vpc.olugbenga_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "olugbenga_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "olugbenga-key-pair"
  vpc_security_group_ids = [aws_security_group.olugbenga_security_group.id]
  subnet_id              = aws_subnet.olugbenga_private_subnet.id

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/olugbenga-key-pair.pem")
    host        = self.public_ip

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo amazon-linux-extras install nginx1.12 -y",
        "sudo systemctl start nginx",
        "sudo systemctl enable nginx"
      ]

      tags = {
        Name = "olugbenga-instance"
      }
    }
  }
}
