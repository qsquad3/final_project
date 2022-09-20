resource "aws_instance" "docker" {
   ami               = "ami-052efd3df9dad4825"
   instance_type     = var.instancia
   availability_zone = "us-east-1a"
   key_name          = var.ssh_keypair
   user_data = "${file("../bootstrap-docker.sh")}"
   network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.docker-nic.id
   }

   tags = {
     Name = "Docker-Server"
     Backup = "true"
   }
 }
