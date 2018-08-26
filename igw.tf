# optional support the IGW for the VDMS vpc if required 
resource "aws_internet_gateway" "igw" {
  count  = 1
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name            = "${var.environment}-${var.project}-igw"
    Environment     = "${var.environment}"
    Owner           = "${var.owner}"
    Project         = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

# optional suport for IGW route to public subnet
resource "aws_route" "igw_route" {
  count                  = 1
  route_table_id         = "${aws_route_table.pub.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}
