#---compute/outputs.tf---

output "krypt0_21_webserver_asg" {
  value = aws_autoscaling_group.krypt0_21_webserver
}