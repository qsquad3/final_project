resource "aws_instance" "k8master" {
   ami               = "ami-052efd3df9dad4825"
   instance_type     = "t3.medium"
   key_name          = var.ssh_keypair
   #vpc_id = "${aws_vpc.prod-vpc.id}"
   #subnet_id = "${aws_subnet.subnet-1.id}"
   vpc_security_group_ids = [aws_security_group.default-sg.id]
   user_data = "${file("bootstrap-master.sh")}"
   tags = {
     Name = "K8S-Master"
   }
 }
