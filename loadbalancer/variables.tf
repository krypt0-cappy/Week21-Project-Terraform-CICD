#---loadbalancer/variables.tf---

variable "public_subnet" {}
variable "vpc_id" {}
variable "web_server_sg" {}
variable "krypt0_21_webserver_asg" {}
variable "target_group_port" {
  default = 80
}
variable "target_group_protocol" {
  default = "HTTP"
}
variable "listener_port" {
  default = 80
}
variable "listener_protocol" {
  default = "HTTP"
}
variable "lb_healthy_threshold" {
  default = 2
}
variable "lb_unhealthy_threshold" {
  default = 2
}
variable "lb_timeout" {
  default = 3
}
variable "lb_interval" {
  default = 30
}