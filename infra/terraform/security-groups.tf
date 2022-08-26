resource "aws_security_group" "default-sg" {
   name        = "default-sg"
   description = "Default Security Group"
   vpc_id      = aws_vpc.vpc.id

   ingress {
     description = "HTTPS"
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "HTTP-APP"
     from_port   = 8000
     to_port     = 8001
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "HTTP"
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "Jenkins"
     from_port   = 8083
     to_port     = 8083
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "SSH"
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
     description = "K8s"
     from_port   = 6443
     to_port     = 6443
     protocol    = "tcp"
     cidr_blocks = ["10.0.0.0/16"]
   }
   ingress {
     description = "K8s2"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["10.0.0.0/16"]
   }
   ingress {
     description = "PGSQL-INT"
     from_port   = 5432
     to_port     = 5432
     protocol    = "tcp"
     cidr_blocks = ["10.0.0.0/16"]
   }

   ingress {
     description = "ping"
     from_port = 8
     to_port = 0
     protocol = "icmp"
     cidr_blocks = ["10.0.0.0/16"]
   }

   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
     Name = "Default SG"
   }
 }