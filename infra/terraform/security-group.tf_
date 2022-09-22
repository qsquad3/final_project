resource "aws_security_group" "default-sg" {
   name        = "default-sg"
   description = "Default Security Group"
   vpc_id      = aws_vpc.vpc.id

   ingress {
     description = "full"
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
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