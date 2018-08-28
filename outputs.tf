output "instance_ip" {
  value = "${aws_instance.Nginx_Server.public_ip}"
}
