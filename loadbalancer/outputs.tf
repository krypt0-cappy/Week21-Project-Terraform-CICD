#---loadbalancer/outputs.tf---

output "elb" {
  value = aws_lb.krypt0_21_loadbalancer.id
}

output "loadbalancer_target_group" {
  value = aws_lb_target_group.krypt0_21_target_group.arn
}

output "loadbalancer_dns" {
  value = aws_lb.krypt0_21_loadbalancer.dns_name
}