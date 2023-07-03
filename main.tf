#1. Create VPC

resource "aws_vpc" "main" {
  cidr_block         = var.cidr_block
  enable_dns_support = true
  tags = merge({
    Name = "${var.env}-vpc"}, var.tags)
}

#Create Subnets & Availability Zones

module "subnets" {
  source = "./subnets"

  for_each    = var.subnets
  cidr_block  = each.value["cidr_block"]
  subnet_name = each.key

  vpc_id = aws_vpc.main.id

  env  = var.env
  tags = var.tags
  az = var.az
}

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "${var.env}-igw"}, var.tags)
  }



#resource "aws_subnet" "main" {
#  count = length(var.web_subnet_cidr_block)
#  vpc_id     = aws_vpc.main.id
#  cidr_block = element(var.web_subnet_cidr_block, count.index )
#
#  tags = merge({
#    Name = "${var.env}-web-subnet"}, var.tags)
