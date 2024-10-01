locals {
  MODULE_NAME    = basename(path.module)
  MODULE_VERSION = "V0.0.1"

  MODULE_TAGS = {
    "Customer"        = var.CUSTOMER
    "EnvironmentType" = var.EnvironmentType
    "Application"     = var.Application
    "Purpose"         = var.Purpose
    "Owner"           = var.OwnerEmail
    "MODULE_VERSION"  = local.MODULE_VERSION
    "MODULE_NAME"     = local.MODULE_NAME
  }

  u_data_internal    = var.user_data_inline != "" ? var.user_data_inline : templatefile(var.user_data_file_path, var.user_data_file_vars)
  is_t_instance_type = replace(var.ec2InstanceType, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}

resource "aws_instance" "dp_il_aws_ec2_instance" {
  ami                         = var.ec2AmiId
  instance_type               = var.ec2InstanceType
  subnet_id                   = var.ec2SubnetId
  vpc_security_group_ids      = var.ec2SecurityGroupIds
  key_name                    = var.ec2KeyName
  user_data                   = local.u_data_internal
  associate_public_ip_address = var.ec2AssociatePublicIpAddress
  availability_zone           = var.ec2AvailabilityZone
  capacity_reservation_specification {
    capacity_reservation_preference = lower(var.ec2CapacityReservationPreference)
  }
  cpu_core_count          = var.ec2CpuCoreCount
  cpu_threads_per_core    = var.ec2CpuThreadsPerCore
  disable_api_termination = var.ec2DisableApiTermination
  credit_specification {
    cpu_credits = local.is_t_instance_type ? lower(var.ec2CpuCredits) : null
  }
  ebs_optimized = var.isEbsOptimized
  enclave_options {
    enabled = var.isEnclaveOptionEnabled
  }
  dynamic "ebs_block_device" {
    for_each = var.ec2EbsBlockDevices
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }
  dynamic "ephemeral_block_device" {
    for_each = var.ec2EphemeralBlockDevice
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }
  get_password_data    = var.ec2GetPasswordData
  iam_instance_profile = var.ec2IamInstanceProfile
  dynamic "metadata_options" {
    for_each = var.ec2MetadataOptions != null ? [var.ec2MetadataOptions] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
    }
  }
  monitoring = var.isMonitoringEnabled
  dynamic "network_interface" {
    for_each = var.ec2NetworkInterface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }
  placement_group       = var.ec2PlacementGroup
  private_ip            = var.ec2PrivateIp
  secondary_private_ips = var.ec2SecondaryPrivateIps
  dynamic "root_block_device" {
    for_each = var.ec2RootBlockDevice
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }
  tags = merge(
    var.tags,
    local.MODULE_TAGS,
    {
      "Name" = "${var.CUSTOMER}-${var.EnvironmentType}-${var.ec2Name}-ec2"
    }
  )
}
