locals {
  MODULE_NAME    = basename(path.module)
  MODULE_VERSION = "V0.0.3"
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

resource "aws_vpc" "dp_il_aws_vpc" {
  cidr_block                     = var.vpc_cidr_block
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  instance_tenancy               = var.instance_tenancy
  tags = merge(
    var.tags,
    local.MODULE_TAGS,
    {
      "Name" = "${var.CUSTOMER}-${var.EnvironmentType}-vpc"
    }
  )
}