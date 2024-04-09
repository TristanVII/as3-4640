variable "name" {
  description = "the name of the security group"
  type        = string
}

variable "description" {
  description = "the description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "the id of the vpc"
  type        = string
}

variable "ingress_rules" {
  type = list(object(
    {
      description = string
      ip_protocol = string
      from_port   = number
      to_port     = number
      cidr_ipv4   = string
      rule_name   = string
    }
  ))
  description = "the ingress rules"
}

variable "egress_rules" {
  type = list(object(
    {
      description = string
      ip_protocol = string
      from_port   = number
      to_port     = number
      cidr_ipv4   = string
      rule_name   = string
    }
  ))
  description = "the egress rules"
}

