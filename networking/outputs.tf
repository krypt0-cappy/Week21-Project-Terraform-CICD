#---networking/outputs.tf---

output "vpc_id" {
  value = aws_vpc.krypt0_21_vpc.id
}

output "public_sg" {
  value = aws_security_group.bastion-host-sg.id
}

output "private_sg" {
  value = aws_security_group.loadbalancer-sg.id
}

output "web_server_sg" {
  value = aws_security_group.web_tier_sg.id
}

output "private_subnet" {
  value = aws_subnet.krypt0_21_private_subnet[*].id
}

output "public_subnet" {
  value = aws_subnet.krypt0_21_public_subnet[*].id
}