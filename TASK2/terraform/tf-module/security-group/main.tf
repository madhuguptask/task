resource "aws_security_group" "sg" {
  name = var.sg-name
  description = var.sg-description
  vpc_id = var.vpc_id
  tags = var.tags

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = lookup(ingress.value,"from_port", null)
      to_port = lookup(ingress.value,"to_port", null)
      protocol = lookup(ingress.value,"protocol", null)
      description = lookup(ingress.value,"description", null)
      cidr_blocks = lookup(ingress.value,"cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port = lookup(egress.value,"from_port", null)
      to_port = lookup(egress.value,"to_port", null)
      protocol = lookup(egress.value,"protocol", null)
      description = lookup(egress.value,"description", null)
      cidr_blocks = lookup(egress.value,"cidr_blocks", null)
    }
  }
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}