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

  ASG_NAME_TAG = "${var.CUSTOMER}-${var.EnvironmentType}-${var.name}-asg"

  ASG_TAGS = distinct(
    concat(
      [for k, v in var.tags :
        {
          key                 = k
          value               = v
          propagate_at_launch = true
        }
      ],
      [for k, v in local.MODULE_TAGS :
        { key                 = k
          value               = v
          propagate_at_launch = true
        }
      ],
      [
        {
          key                 = "Name"
          value               = local.ASG_NAME_TAG
          propagate_at_launch = true
        },
      ]
    )
  )
}

resource "aws_autoscaling_group" "this" {
  name                 = var.useNamePrefix ? null : var.name
  launch_configuration = var.useLaunchConfig ? var.launchConfiguration : null
  vpc_zone_identifier  = var.vpcZoneIdentifier
  desired_capacity     = var.desiredCapacity
  max_size             = var.maxSize
  min_size             = var.minSize
  name_prefix          = var.useNamePrefix ? "${var.name}-" : null
  availability_zones   = var.availabilityZoneList
  capacity_rebalance   = var.capacityRebalanceEnabled
  default_cooldown     = var.defaultCooldown
  dynamic "launch_template" {
    for_each = var.useLaunchTemplate ? [1] : []
    content {
      name    = var.launchTemplate
      version = var.launchTemplateVersion
    }
  }
  dynamic "mixed_instances_policy" {
    for_each = var.useMixedInstancesPolicy ? [var.mixedInstancesPolicy] : []
    content {
      dynamic "instances_distribution" {
        for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) != null ? [mixed_instances_policy.value.instances_distribution] : []
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }

      launch_template {
        launch_template_specification {
          launch_template_name = var.launchTemplate
          version              = var.launchTemplateVersion
        }

        dynamic "override" {
          for_each = lookup(mixed_instances_policy.value, "override", null) != null ? mixed_instances_policy.value.override : []
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)

            dynamic "launch_template_specification" {
              for_each = lookup(override.value, "launch_template_specification", null) != null ? override.value.launch_template_specification : []
              content {
                launch_template_id = lookup(launch_template_specification.value, "launch_template_name", null)
              }
            }
          }
        }
      }
    }
  }
  dynamic "initial_lifecycle_hook" {
    for_each = var.initialLifecycleHooks
    content {
      name                    = initial_lifecycle_hook.value.name
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }
  health_check_grace_period = var.healthCheckGracePeriod
  health_check_type         = var.healthCheckType
  force_delete              = var.forceDelete
  load_balancers            = var.loadBalancers
  target_group_arns         = var.targetGroupArns
  termination_policies      = var.terminationPolicies
  suspended_processes       = var.suspendedProcesses
  placement_group           = var.placementGroup
  enabled_metrics           = var.enabledMetrics
  wait_for_capacity_timeout = var.waitForCapacityTimeout
  min_elb_capacity          = var.minElbCapacity
  wait_for_elb_capacity     = var.waitForElbCapacity
  protect_from_scale_in     = var.protectFromScaleIn
  service_linked_role_arn   = var.serviceLinkedRoleArn
  max_instance_lifetime     = var.maxInstanceLifetime
  dynamic "instance_refresh" {
    for_each = var.instanceRefresh != null ? [var.instanceRefresh] : []
    content {
      strategy = instance_refresh.value.strategy
      triggers = lookup(instance_refresh.value, "triggers", null)

      dynamic "preferences" {
        for_each = lookup(instance_refresh.value, "preferences", null) != null ? [instance_refresh.value.preferences] : []
        content {
          checkpoint_delay       = lookup(preferences.value, "checkpoint_delay", null)
          checkpoint_percentages = lookup(preferences.value, "checkpoint_percentages", null)
          instance_warmup        = lookup(preferences.value, "instance_warmup", null)
          min_healthy_percentage = lookup(preferences.value, "min_healthy_percentage", null)
        }
      }
    }
  }
  dynamic "warm_pool" {
    for_each = var.warmPool != null ? [var.warmPool] : []
    content {
      pool_state                  = lookup(warm_pool.value, "pool_state", null)
      min_size                    = lookup(warm_pool.value, "min_size", null)
      max_group_prepared_capacity = lookup(warm_pool.value, "max_group_prepared_capacity", null)
    }
  }
  tags = local.ASG_TAGS
}
