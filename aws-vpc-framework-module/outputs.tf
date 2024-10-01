output "vpc_id" {
  value = aws_vpc.dp_il_aws_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.dp_il_aws_vpc.cidr_block
}