resource "aws_vpc" "main" {
  cidr_block         = var.cidr_block
  enable_dns_support = true
}
#  tags = merge({
#    Name = "${var.env}-vpc"
#  },
#    var.tags)
#}