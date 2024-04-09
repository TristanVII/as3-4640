output "vpc_id" {
  value = aws_vpc.main.id
}

output "sg_ids" {
  value = [module.public_sg.id, module.private_sg.id]
}

output "sn1" {
  value = aws_subnet.public_subnet.id
}

output "sn2" {
  value = aws_subnet.private_subnet.id
}

output "rt" {
  value = aws_route_table.main.id
}

output "aws_instance_ids" {
  value = [aws_instance.public_ec2_instances.id, aws_instance.private_ec2_instances.id] 
}

output "aws_instance_ips" {
  value = [aws_instance.public_ec2_instances.public_ip, aws_instance.private_ec2_instances.public_ip]
}