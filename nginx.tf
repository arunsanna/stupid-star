# create NGINX instance
# install nginx
# install mysql
# use centos/ubuntu

# security group for the instance
# instace provisioning
# IAM role for instance

resource "aws_security_group" "NGINX-SG" {
  name        = "allow_all"
  description = "Allow inbound traffic for NGINX Serverr"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.my_ip_address}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags {
    Name            = "${var.environment}-${var.project}-NGINX-sg"
    Environment     = "${var.environment}"
    Owner           = "${var.owner}"
    Project         = "${var.project}"
    ExpirationDate  = "${var.expiration_date}"
  }
}

# deploying instance with amazon linux operating systems
resource "aws_instance" "Nginx_Server" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    availability_zone= "${var.instance_az}"
    associate_public_ip_address = true
    key_name = "${var.keyname}"
    vpc_security_group_ids = ["${aws_security_group.NGINX-SG.id}"]
    subnet_id      = "${element(aws_subnet.pub.*.id, 1)}"
    root_block_device {
      volume_size = "${var.root_volume_size}"
      volume_type = "${var.root_volume_type}"
    }
    tags {
      Name            = "${var.environment}-${var.project}-NGINX-Server"
      Environment     = "${var.environment}"
      Owner           = "${var.owner}"
      Project         = "${var.project}"
      ExpirationDate  = "${var.expiration_date}"
  }
  }

  data "template_file" "reancore-init" {
  template = "${file("${path.module}/templates/userdata.sh.tpl")}"
}