output "ec2_arn" {
  value = aws_instance.dp_il_aws_ec2_instance.arn
}

output "ec2_public_ip" {
  value = try(aws_instance.dp_il_aws_ec2_instance.public_ip, null)
}

output "ec2_private_ip" {
  value = aws_instance.dp_il_aws_ec2_instance.private_ip
}

output "ec2_id" {
  value = aws_instance.dp_il_aws_ec2_instance.id
}