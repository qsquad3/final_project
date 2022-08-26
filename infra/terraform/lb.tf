resource "aws_lb" "LB" {
  name               = "loadbalancer"
  internal = false
  load_balancer_type = "network"
  #subnets = [aws_subnet.pub-subnet.id]

  subnet_mapping {
    subnet_id    = "${aws_subnet.pub-subnet.id}"
    #allocation_id = "${aws_eip.one.id}"
  }
}