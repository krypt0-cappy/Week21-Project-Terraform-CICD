#---compute/main.tf---

# data "aws_ami" "linux" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amazon/amzn2-ami-kernel-5.10-hvm-2.0.20220912.1-x86_64-*"]
#   }

#   owners = ["137112412989"]
# }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# RANDOM NAMING SCHEME FOR WEBSERVER EC2 INSTANCES
resource "random_pet" "random" {}

# WEBSERVER INSTANCES LAUNCH TEMPLATE
resource "aws_launch_template" "krypt0_21_webserver" {
  name_prefix            = "krypt0_21_webserver"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.krypt0_21_webserver_instance_type
  vpc_security_group_ids = [var.private_sg]
  key_name               = var.key_name
  user_data              = filebase64("userdata.sh")

  tags = {
    Name = "krypt0_21_webserver"
  }
}

# WEBSERVER AUTOSCALING GROUP
resource "aws_autoscaling_group" "krypt0_21_webserver" {
  name                = "krypt0_21_webserver"
  min_size            = 3
  max_size            = 7
  desired_capacity    = 5
  vpc_zone_identifier = tolist(var.private_subnet)

  launch_template {
    id      = aws_launch_template.krypt0_21_webserver.id
    version = "$Latest"
  }
}

# BASTION HOST LAUNCH TEMPLATE
resource "aws_launch_template" "krypt0_21_bastion_host" {
  name_prefix            = "krypt0_21_bastion_host"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.krypt0_21_bastion_host_instance_type
  vpc_security_group_ids = [var.public_sg]
  key_name               = var.key_name

  tags = {
    Name = "krypt0_21_bastion_host"
  }
}

# BASTION HOST AUTOSCALING GROUP
resource "aws_autoscaling_group" "krypt0_21_bastion_host" {
  name                = "krypt0_21_bastion_host"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = tolist(var.public_subnet)

  launch_template {
    id      = aws_launch_template.krypt0_21_bastion_host.id
    version = "$Latest"
  }
}

# AUTOSCALING GROUP ATTACHMENTS
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.krypt0_21_webserver.id
  lb_target_group_arn    = var.loadbalancer_target_group
}
