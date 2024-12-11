resource "aws_vpc" "futebol_vpc_1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "futebol_vpc_1"
  }

}


resource "aws_subnet" "futebol_subnet" {
  vpc_id = aws_vpc.futebol_vpc_1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "futebol_subnet_public"
  }
}


resource "aws_internet_gateway" "futebol_internet_gateway" {
  vpc_id = aws_vpc.futebol_vpc_1.id

  tags = {
    Name = "futebol_internetgtw"
  }
}

resource "aws_route_table" "futebol_route_table" {
  vpc_id = aws_vpc.futebol_vpc_1.id

  tags = {
    Name = "futebol_route_tb"
  }
}

resource "aws_route" "futebol_route" {
  route_table_id = aws_route_table.futebol_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.futebol_internet_gateway.id
}

resource "aws_route_table_association" "futebol_rtb_association" {
  route_table_id = aws_route_table.futebol_route_table.id
  subnet_id = aws_subnet.futebol_subnet.id
}

resource "aws_instance" "futebol_instance" {
  instance_type = "t2.micro"
  key_name = aws_key_pair.futebol_key.id
  vpc_security_group_ids = [aws_security_group.futebol_sg.id]
  subnet_id = aws_subnet.futebol_subnet.id

  ami = data.aws_ami.futebol_ami.id

  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "futebol_ec2"
  }
}