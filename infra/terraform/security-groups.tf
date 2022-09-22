resource "aws_security_group" "default-sg" {
   name        = "default-sg"
   description = "Default Security Group"
   vpc_id      = aws_vpc.vpc.id

   ingress {
     description = "APP-QUODE"
     from_port   = 8500
     to_port     = 8501
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "GRAFANA"
     from_port   = 3000
     to_port     = 3000
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
     from_port   = 8084
     to_port     = 8084
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
     description = "K8s-Dash"
     from_port   = 8001
     to_port     = 8001
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "Internal"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
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
     Name = "Stack-SegurityGroup"
   }
 }