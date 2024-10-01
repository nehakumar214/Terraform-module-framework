locals {
  MODULE_NAME    = basename(path.module)
  MODULE_VERSION = "V0.0.1-pre"

  MODULE_TAGS = {
    "Customer"        = var.CUSTOMER
    "EnvironmentType" = var.EnvironmentType
    "Application"     = var.Application
    "Purpose"         = var.Purpose
    "Owner"           = var.OwnerEmail
    "MODULE_VERSION"  = local.MODULE_VERSION
    "MODULE_NAME"     = local.MODULE_NAME
  }
}

# The main route table
resource "aws_route_table" "this" {
  vpc_id = var.vpcId
  tags = merge(
    var.tags,
    local.MODULE_TAGS,
    {
      "Name" = "${var.CUSTOMER}-${var.EnvironmentType}-${var.name}-rtb"
    }
  )
}

# Association if the route table is main route table
resource "aws_main_route_table_association" "this" {
  count          = var.isMainRtb ? 1 : 0
  vpc_id         = var.vpcId
  route_table_id = aws_route_table.this.id
}

# Routes configuration

## Route rules for IPv4 CIDRs
resource "aws_route" "ipv4" {
  for_each = {
    for route in var.ipv4Routes :
    route.cidr_block => route
  }
  route_table_id            = aws_route_table.this.id
  destination_cidr_block    = each.key
  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  instance_id               = try(each.value.instance_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}
## Route rules for IPv6 CIDRs
resource "aws_route" "ipv6" {
  for_each = {
    for route in var.ipv6Routes :
    route.cidr => route
  }
  route_table_id              = aws_route_table.this.id
  destination_ipv6_cidr_block = each.key
  carrier_gateway_id          = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id      = try(each.value.egress_only_gateway_id, null)
  gateway_id                  = try(each.value.gateway_id, null)
  instance_id                 = try(each.value.instance_id, null)
  local_gateway_id            = try(each.value.local_gateway_id, null)
  nat_gateway_id              = try(each.value.nat_gateway_id, null)
  network_interface_id        = try(each.value.network_interface_id, null)
  transit_gateway_id          = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id             = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id   = try(each.value.vpc_peering_connection_id, null)
}
## Route rules for managed prefix list
resource "aws_route" "prefix_list" {
  for_each = {
    for route in var.prefixListRoutes :
    route.id => route
  }
  route_table_id             = aws_route_table.this.id
  destination_prefix_list_id = each.key
  carrier_gateway_id         = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id     = try(each.value.egress_only_gateway_id, null)
  gateway_id                 = try(each.value.gateway_id, null)
  instance_id                = try(each.value.instance_id, null)
  local_gateway_id           = try(each.value.local_gateway_id, null)
  nat_gateway_id             = try(each.value.nat_gateway_id, null)
  network_interface_id       = try(each.value.network_interface_id, null)
  transit_gateway_id         = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id            = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id  = try(each.value.vpc_peering_connection_id, null)
}

# Configura VPN gateway route propagations
resource "aws_vpn_gateway_route_propagation" "this" {
  for_each       = toset(var.propagatingVpnGateways)
  route_table_id = aws_route_table.this.id
  vpn_gateway_id = each.value
}

# VPN Endpoint association with route table
resource "aws_vpc_endpoint_route_table_association" "this" {
  for_each        = toset(var.vpcGatewayEndpoints)
  route_table_id  = aws_route_table.this.id
  vpc_endpoint_id = each.value
}

# Route Table Associations
resource "aws_route_table_association" "subnets" {
  count          = length(var.subnets)
  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnets[count.index]
}
resource "aws_route_table_association" "gateways" {
  for_each       = toset(var.gateways)
  route_table_id = aws_route_table.this.id
  gateway_id     = each.value
}
