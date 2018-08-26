resource "aws_eip" "nat" {
  count      = "${var.az_count}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name            = "${var.environment}-${var.project}-nat"
    Environment     = "${var.environment}"
    Project         = "${var.project}"
    Owner           = "${var.owner}"
    ExpirationDate  = "${var.expiration_date}"
  }
}


resource "aws_nat_gateway" "nat" {
  count         = "${var.az_count}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.pub.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]

  tags {
    Name            = "${var.environment}-${var.project}-nat"
    Environment     = "${var.environment}"
    Project         = "${var.project}"
    Owner           = "${var.owner}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

resource "aws_route" "nat_gateway_route" {
  count                  = "${var.az_count}"
  route_table_id         = "${element(aws_route_table.priv.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}