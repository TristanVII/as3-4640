
// Using the security group modules to create public security-group
module "public_sg"{
  source = "./modules/security_group"
  name = "public_sg"
  description = "Public security group for front-end"
  vpc_id = aws_vpc.main.id

  // Defining the ingress rules
  ingress_rules = [
    {
      description = "ssh from anywhere"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.all_ip
      rule_name = "ssh_all"
    },
    {
      description = "web access from anywhere"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = var.all_ip
      rule_name = "http_all"
    },
   ]

   // Defining egress rules
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = null 
      to_port = null 
      cidr_ipv4 = var.all_ip
      rule_name = "all_egress"
    }
   ]
}

// Using the security group modules to create private security-group
module "private_sg"{
  source = "./modules/security_group"
  name = "private_sg"
  description = "Somewhat private security group for backend"
  vpc_id = aws_vpc.main.id

  // Defining ingress rules
  ingress_rules = [
    {
      description = "ssh from anywhere"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.all_ip
      rule_name = "ssh_all"
    },
    {
      description = "web access only from VPC"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = aws_vpc.main.cidr_block
      rule_name = "web_vpc_only"
    },
   ]

   // Defining egress rules
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = null 
      to_port = null 
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "all_egress"
    }
   ]
}

# Ubuntu image 23.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-lunar-23.04-amd64-server-*"]
  }
}

# key pair from local key
resource "aws_key_pair" "key" {
  key_name   = "assignment3Key"
  public_key = file(var.ssh_key)
}

// Creating the private ec2 using public sg
resource "aws_instance" "public_ec2_instances" {
  ami               = data.aws_ami.ubuntu.id  
  instance_type     = var.instance_type

  security_groups   = [module.public_sg.id]
  subnet_id         = aws_subnet.public_subnet.id
  key_name          = aws_key_pair.key.key_name
  availability_zone = var.availability_zone
  tags = {
    Name = "public_instance"
  }
}

// Creating the private ec2 using private sg
resource "aws_instance" "private_ec2_instances" {
  ami               = data.aws_ami.ubuntu.id  
  instance_type     = var.instance_type

  security_groups   = [module.private_sg.id]
  subnet_id         = aws_subnet.private_subnet.id 
  key_name          = aws_key_pair.key.key_name
  availability_zone = var.availability_zone
  tags = {
    Name = "private_instance"
  }
}

// Creating the Ansible inventory file, which is formated with inventory.tftpl
// Writes the file to inventory directory in ansible directory
// Uses the private and public ec2 instances ips
resource "local_file" "inventory" {
  file_permission = "0755"
  filename = "/shared-directory/assignment3/ansible/inventory/inventory.yaml"

  content = templatefile("./inventory.tftpl", { public_ip = [aws_instance.public_ec2_instances.public_ip, ], private_ip = [aws_instance.private_ec2_instances.public_ip]})
}
