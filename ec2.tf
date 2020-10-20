
# data "aws_ami" "my_ami" {
#      most_recent      = true
#      #name_regex       = "^mavrick"
#      owners           = ["721834156908"]
# }


resource "aws_instance" "web-1" {
    count  = "${var.env == "prod" ? 3 : 1}"
    ami = "${lookup(var.amis, var.aws_region)}"
    #ami = "ami-0d857ff0f5fc4e03b
    instance_type = "t2.nano"
    key_name = "LAPTOP-KEY"
    subnet_id = "${element(aws_subnet.public-subnets.*.id, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    user_data = <<-EOF
		#! /bin/bash
        sudo yum update
		sudo yum install -y nginx
		sudo service nginx start
	EOF	
    tags = {
        Name = "${var.vpc_name}-Server-${count.index+1}"
        # Owner = "Sree"
	    # CostCenter = "ABCD"
    }
    lifecycle {
    ignore_changes = [
      tags,
    ]
    }
}

resource null_resource "copyfiles" {
  count  = "${var.env == "prod" ? 3 : 1}"
provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    connection {
    type     = "ssh"
    user     = "ec2-user"
    #password = "India@123456"
    private_key = "${file("LAPTOP-KEY.pem")}"
    host     = "${element(aws_instance.web-1.*.public_ip, count.index)}"
    }
    }

provisioner "remote-exec" {
    inline = [
      #"chmod +x /tmp/script.sh",
      #"sudo ./tmp/script.sh",
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "sudo chmod 777 /tmp/script.sh",
      "sudo bash /tmp/script.sh"

      ]
    connection {
    type     = "ssh"
    user     = "ec2-user"
    #password = "India@123456"
    private_key = "${file("LAPTOP-KEY.pem")}"
    host     = "${element(aws_instance.web-1.*.public_ip, count.index)}"
    }
    }

    provisioner "local-exec" {
    command = <<EOH
      echo "${element(aws_instance.web-1.*.public_ip, count.index)}" >> details,
      echo "${element(aws_instance.web-1.*.private_ip, count.index)}" >> details
    EOH
    }
}

