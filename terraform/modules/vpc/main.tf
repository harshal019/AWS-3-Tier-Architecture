resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }
}


//Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}

//Subnets 

//Public Subnets

resource "aws_subnet" "public" {

  count = length(var.public_subnets)


  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project}-${var.env}-public-${count.index}"
  }
}


//Private Subnet

resource "aws_subnet" "private" {

  count = length(var.private_subnets)  

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project}-${var.env}-private-${count.index}"
  }
}

//route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}
//connection of public subnets + igw
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

//route associations
resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Public Subnet → NAT Gateway → Internet
# Private Subnet → Route → NAT Gateway

//Allocation of Elastic IP

resource "aws_eip" "nat" {
  domain = "vpc"
}

//Nat Gateway
resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project}-${var.env}-nat"
  }

}

//Private Route Table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

//Route Private Traffic via NAT
resource "aws_route" "private_internet" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

//Associate Private Subnets

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}







