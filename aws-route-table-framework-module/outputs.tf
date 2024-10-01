output "rtbVpcId" {
  value = aws_route_table.this.vpc_id
}

output "rtbId" {
  value = aws_route_table.this.id
}

output "rtbAssociatedSubnets" {
  value = aws_route_table_association.subnets[*].subnet_id
}

output "rtbAssociatedGateways" {
  value = values(aws_route_table_association.gateways)[*].gateway_id
}

output "rtbPropagatedVpnGateways" {
  value = values(aws_vpn_gateway_route_propagation.this)[*].vpn_gateway_id
}
