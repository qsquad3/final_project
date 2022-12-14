resource "aws_instance" "k8master" {
   ami               = "ami-052efd3df9dad4825"
   instance_type     = var.instancia
   availability_zone = "us-east-1a"
   key_name          = var.ssh_keypair
   user_data = "${file("../bootstrap-master.sh")}"
   ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
  }
   #depends_on = [aws_elb.LB]
   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.k8s-master-nic.id
   }

   tags = {
     Name = "K8S-Master"
   }
 }

 #Workers
 resource "aws_instance" "k8worker1" {
   count = 1
   ami               = "ami-052efd3df9dad4825"
   instance_type     = var.instancia
   availability_zone = "us-east-1a"
   key_name          = var.ssh_keypair
   user_data = "${file("../bootstrap-worker1.sh")}"
   depends_on = [aws_instance.k8master]
   ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
  }
   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.k8s-worker1-nic.id
   }
   tags = {
     Name = "K8S-Worker1"
   }
 }

 resource "aws_instance" "k8worker2" {
   count = 1
   ami               = "ami-052efd3df9dad4825"
   instance_type     = var.instancia
   availability_zone = "us-east-1a"
   key_name          = var.ssh_keypair
   user_data = "${file("../bootstrap-worker2.sh")}"
   depends_on = [aws_instance.k8master]
   ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
  }
   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.k8s-worker2-nic.id
   }
   tags = {
     Name = "K8S-Worker2"
   }
 }