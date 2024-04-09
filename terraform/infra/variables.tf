variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "all_ip" {
  description = "All ip ranges"
  default = "0.0.0.0/0"
}

variable "base_cidr_block" {
  description = "Default CIDR block"
  default = "10.0.0.0/16"
}

variable "subnet_1" {
  description = "Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "subnet_2" {
  description = "Subnet CIDR"
  default     = "10.0.2.0/24"
}
 
variable "vpc_name" {
  description = "VPC name"
  default = "main_vpc"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type for EC2 instances"
}

variable "ssh_key" {
  type = string
  default = "~/.ssh/key.pub"
  description = "ssh key path"
}

variable "availability_zone" {
  type        = string
  default     = "us-west-2a"
  description = "Availability zones for EC2 instances"
}

