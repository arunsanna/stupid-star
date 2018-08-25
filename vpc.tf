provider "aws" {
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "zones" {}

resource "aws_vpc" "vpc" {
  cidr_block         = "${var.vpc_cidr_block}"
  enable_dns_support = "${var.dns_support}"

  tags {
    Name        = "${var.environment}-${var.project}-vpc"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

# Egress to the VPC only.
resource "aws_security_group" "vpc-egress" {
  name        = "${var.environment}-${var.project}-vpc-egress"
  description = "Egress to same VPC"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-${var.project}-vpc-egress"
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Owner       = "${var.owner}"
    ExpirationDate  = "${var.expiration_date}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    description = "Allow egress to VPC only"
  }
}

# Egress to anywhere
resource "aws_security_group" "all-egress" {
  name        = "${var.environment}-${var.project}-all-egress"
  description = "Egress to anywhere"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-${var.project}-all-egress"
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Owner       = "${var.owner}"
    ExpirationDate  = "${var.expiration_date}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress to anywhere"
  }
}


resource "aws_subnet" "pub" {
  count             = "${var.az_count}"
  availability_zone = "${element(data.aws_availability_zones.zones.names, count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(cidrsubnet(var.vpc_cidr_block, var.az_cidr_newbits, var.az_cidr_length * count.index), var.subnet_cidr_newbits, 0)}"

  tags {
    CreatedBy   = "${var.creater}"
    Name        = "${var.environment}-${var.project}-pub-${element(data.aws_availability_zones.zones.names, count.index)}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

resource "aws_subnet" "priv" {
  count             = "${var.az_count}"
  availability_zone = "${element(data.aws_availability_zones.zones.names, count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(cidrsubnet(var.vpc_cidr_block, var.az_cidr_newbits, var.az_cidr_length * count.index), var.subnet_cidr_newbits, var.subnet_cidr_length * 1)}"

  tags {
    CreatedBy   = "${var.creater}"
    Name        = "${var.environment}-${var.project}-priv-${element(data.aws_availability_zones.zones.names, count.index)}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    CreatedBy   = "${var.creater}"
    Name        = "${var.environment}-${var.project}-pub"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

resource "aws_route_table" "priv" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    CreatedBy   = "${var.creater}"
    Name        = "${var.environment}-${var.project}-priv"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

resource "aws_route_table_association" "pub" {
  count          = "${var.az_count}"
  route_table_id = "${aws_route_table.pub.id}"
  subnet_id      = "${element(aws_subnet.pub.*.id, count.index)}"
}

resource "aws_route_table_association" "priv" {
  count          = "${var.az_count}"
  route_table_id = "${element(aws_route_table.priv.*.id, count.index)}"
  subnet_id      = "${element(aws_subnet.priv.*.id, count.index)}"
}


