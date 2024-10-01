# Mandatory Framework Variables
variable "CUSTOMER" {
  type = string
}
variable "EnvironmentType" {
  type    = string
  default = "DEV"

  validation {
    condition     = contains(["PRD", "QAS", "DEV", "TST", "POC", "BKP", "DMO", "SND"], var.EnvironmentType)
    error_message = "Valid values for var: EnvironmentType are (PRD,QAS,DEV,TST,POC,BKP,DMO,SND)."
  }
}
variable "Application" {
  type = string
}
variable "Purpose" {
  type = string

  validation {
    condition     = contains(["WAP", "WEB", "APP", "RDB", "ETL", "DAM", "MDL", "BUS", "API", "NET"], var.Purpose)
    error_message = "Valid values for var: EnvironmentType are (WAP,WEB,APP,RDB,ETL,DAM,MDL,BUS,API,NET)."
  }
}
variable "OwnerEmail" {
  type = string
}
variable "tags" {
  type    = map(any)
  default = {}
}

# Module variables

variable "name" {
  type        = string
}
variable "useLaunchConfig" {
  type        = bool
  default     = false
}
variable "launchConfiguration" {
  type        = string
  default     = null
}
variable "vpcZoneIdentifier" {
  type        = list(string)
  default     = null
}
variable "desiredCapacity" {
  type        = number
  default     = null
}
variable "maxSize" {
  type        = number
  default     = null
}
variable "minSize" {
  type        = number
  default     = 1
}
variable "useNamePrefix" {
  type        = bool
  default     = false
}
variable "availabilityZoneList" {
  type        = list(string)
  default     = null
}
variable "capacityRebalanceEnabled" {
  type        = bool
  default     = null
}
variable "defaultCooldown" {
  type        = number
  default     = null
}
variable "useLaunchTemplate" {
  type        = bool
  default     = false
}
variable "launchTemplate" {
  type        = string
  default     = null
}
variable "launchTemplateVersion" {
  type        = string
  default     = null
}
variable "useMixedInstancesPolicy" {
  type        = bool
  default     = false
}
variable "mixedInstancesPolicy" {
  type        = any
  default     = null
}
variable "initialLifecycleHooks" {
  type        = list(map(string))
  default     = []
}
variable "healthCheckGracePeriod" {
  type        = number
  default     = null
}
variable "healthCheckType" {
  type        = string
  default     = null
}
variable "forceDelete" {
  type        = bool
  default     = null
}
variable "loadBalancers" {
  type        = list(string)
  default     = []
}
variable "targetGroupArns" {
  type        = list(string)
  default     = []
}
variable "terminationPolicies" {
  type        = list(string)
  default     = null
}
variable "suspendedProcesses" {
  type        = list(string)
  default     = null
}
variable "placementGroup" {
  type        = string
  default     = null
}
variable "enabledMetrics" {
  type        = list(string)
  default     = null
}
variable "waitForCapacityTimeout" {
  type        = string
  default     = null
}
variable "minElbCapacity" {
  type        = number
  default     = null
}
variable "waitForElbCapacity" {
  type        = number
  default     = null
}
variable "protectFromScaleIn" {
  type        = bool
  default     = false
}
variable "serviceLinkedRoleArn" {
  type        = string
  default     = null
}
variable "maxInstanceLifetime" {
  type        = number
  default     = null
}
variable "instanceRefresh" {
  type        = any
  default     = null
}
variable "warmPool" {
  type        = any
  default     = null
}
