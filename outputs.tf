output "vpc_id" {
  value       = "${aws_vpc.default.id}"
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}

output "subnets" {
  value       = "${aws_subnet.public-subnets.*.id}"
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}

output "ec2-instances" {
  value       = "${aws_instance.web-1.*.id}"
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}

output "public-ips" {
  value       = "${aws_instance.web-1.*.public_ip}"
  # sensitive   = true
  # description = "description"
  # depends_on  = []
}