variable "environment" {
  default = "dev"
}

variable "creater" {
  default = "arun.sanna"
}

variable "owner" {
  default = "arun.sanna"
}

variable "project" {
  default = "REANPlatform"
}

variable "client_code" {
  default = "rean"
}

# Flexible AZ / subnets and CIDR layout.
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "az_count" {
  default = 2
}

variable "az_cidr_length" {
  default = 1
}

variable "az_cidr_newbits" {
  default = 2
}

variable "subnet_cidr_length" {
  default = 1
}

variable "subnet_cidr_newbits" {
  default = 3
}

variable "required_storage_subnet" {
  default = 0
}

variable "required_packer_subnet" {
  default = 0
}

# Enable/disable various features.
variable "dhcp_options" {
  default = false
}

variable "dns_support" {
  default = true
}

variable "flow_log_traffic_type" {
  default = "ALL"
}

variable "external_cloudtrail" {
  default = 0
}

variable "external_nacl" {
  default = 0
}

variable "required_igw" {
  default = 1
}

# Optional NAT feature.
variable "nat_type" {
  default = "instance"
} # Change to "none" or "" to disable the NAT, change to "gateway" to use the NAT gateway.

variable "nat_instance_type" {
  default = "t2.micro"
}

# Optional Bastion feature.
variable "bastion_instance" {
  default = 1
} # Change to 0 to disable the bastion.

variable "bastion_use_public_ip" {
  default = 1
} # Change to 0 to disable using an EIP for the bastion.

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "expiration_date" {
  default = "09-28-2018"
}

variable "my_ip_address" {
  default = "72.219.207.54/32"
}

variable "ami_id" {
  default = "ami-04681a1dbd79675a5"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "keyname" {
  default = "arunsanna"
}

variable "root_volume_size" {
  default = 50
}

variable "root_volume_type" {
  default = "gp2"
}

variable "instance_az" {
  default = "us-east-1b"
}