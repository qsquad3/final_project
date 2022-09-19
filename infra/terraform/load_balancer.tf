resource "aws_lb" "nlb" {
  name = "nlb"
  internal = true
  load_balancer_type = "network"
  subnets = ["${aws_subnet.pub-subnet.id}"]
}

resource "aws_lb_target_group" "serviceB-internal-lb-tg" {
  name     = "serviceB-int-lb-tg"
  port = 8088
  protocol = "TCP"
  vpc_id = "${aws_vpc.vpc.id}"
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    port = "8088"
    path = "/healthcheck"
  }
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = "${aws_lb.nlb.arn}"
  port = 8088
  protocol = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.serviceB-internal-lb-tg.arn}"
    type = "forward"
  }
}