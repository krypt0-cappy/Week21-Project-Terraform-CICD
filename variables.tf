#---compute/variables.tf---

variable "krypt0_21_bastion_host_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "krypt0_21_webserver_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "public_subnet" {}
variable "public_sg" {}
variable "private_subnet" {}
variable "private_sg" {}
variable "key_name" {}
variable "loadbalancer_target_group" {}
variable "elb" {}
