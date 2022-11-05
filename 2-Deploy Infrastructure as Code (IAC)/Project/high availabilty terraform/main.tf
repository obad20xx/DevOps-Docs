terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">=1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "MayVpc" {
  cidr_block           = var.MayVpcCider
  enable_dns_hostnames = true
  tags = {
    "key"   = "NAME"
    "Value" = var.EnvName
  }

}

resource "aws_internet_gateway" "MyInternetGatewayR" {
  tags = {
    "key"   = "NAME"
    "Value" = var.EnvName
  }
}

resource "aws_internet_gateway_attachment" "MyInternetGatewayAttachmentR" {
  internet_gateway_id = aws_internet_gateway.MyInternetGatewayR.id
  vpc_id              = aws_vpc.MayVpc.id
}

resource "aws_subnet" "PublicSubnet1R" {
  vpc_id            = aws_vpc.MayVpc.id
  availability_zone = "!Select [ 0, !GetAZs '' ]"
  cidr_block        = var.PublicSubnet1
  tags = {
    "key"   = "NAME"
    "Value" = "${var.EnvName} Public Subnet (AZ1)"
  }
}

resource "aws_subnet" "PublicSubnet2R" {
  vpc_id            = aws_vpc.MayVpc.id
  availability_zone = "!Select [ 1, !GetAZs '' ]"
  cidr_block        = var.PublicSubnet2
  tags = {
    "key"   = "NAME"
    "Value" = "${var.EnvName} Public Subnet (AZ2)"
  }
}

resource "aws_subnet" "PrivateSubnet1R" {
  vpc_id            = aws_vpc.MayVpc.id
  availability_zone = "!Select [ 0, !GetAZs '' ]"
  cidr_block        = var.PrivateSubnet1
  tags = {
    "key"   = "NAME"
    "Value" = "${var.EnvName} Private Subnet (AZ1)"
  }
}

resource "aws_subnet" "PrivateSubnet2R" {
  vpc_id            = aws_vpc.MayVpc.id
  availability_zone = "!Select [ 1, !GetAZs '' ]"
  cidr_block        = var.PrivateSubnet2
  tags = {
    "key"   = "NAME"
    "Value" = "${var.EnvName} Private Subnet (AZ2)"
  }
}

resource "aws_eip" "staticIP1R" {
  depends_on = [
    aws_internet_gateway_attachment.MyInternetGatewayAttachmentR
  ]
}

resource "aws_eip" "staticIP2R" {
  depends_on = [
    aws_internet_gateway_attachment.MyInternetGatewayAttachmentR
  ]
}

resource "aws_nat_gateway" "NatGateway1R" {
  allocation_id = aws_eip.staticIP1R.allocation_id
  subnet_id     = aws_subnet.PublicSubnet1R.id
}

resource "aws_nat_gateway" "NatGateway2R" {
  allocation_id = aws_eip.staticIP2R.allocation_id
  subnet_id     = aws_eip.staticIP2R.id
}

resource "aws_route_table" "PublicRouteTableR" {
  vpc_id = aws_vpc.MayVpc.id
  tags = {
    "key"   = "NAME"
    "Value" = "${var.EnvName} Public Routes (AZ 1 & 2)"
  }
}

resource "aws_route" "DefaultPublicRouteR" {
  depends_on = [
    aws_internet_gateway_attachment.MyInternetGatewayAttachmentR
  ]
  route_table_id         = aws_route_table.PublicRouteTableR.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.MyInternetGatewayR.id
}

