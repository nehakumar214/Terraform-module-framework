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
    condition     = contains(["WAP", "WEB", "APP", "RDB", "ETL", "DAM", "MDL", "API", "NET"], var.Purpose)
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
variable "ec2Name" {
  type = string
}
variable "ec2AmiId" {
  type = string

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.ec2AmiId))
    error_message = "The ec2AmiId value must be a valid AMI id, starting with \"ami-\"."
  }
}
variable "ec2InstanceType" {
  type    = string
  default = "t2.small"
}
variable "ec2SubnetId" {
  type = string
}
variable "ec2SecurityGroupIds" {
  type    = list(any)
  default = []
}
variable "ec2KeyName" {
  type = string
}
variable "user_data_file_path" {
  type = string
  default = ""
}
variable "user_data_file_vars" {
  type = map(any)
  default = {}
}
variable "user_data_inline" {
  default = ""
}
variable "ec2AssociatePublicIpAddress" {
  type    = bool
  default = false
}
variable "ec2AvailabilityZone" {
  type    = string
  default = null
}
variable "ec2CapacityReservationPreference" {
  type    = string
  default = "open"

  validation {
    condition     = contains(["none", "open"], var.ec2CapacityReservationPreference)
    error_message = "Valid values for var: EnvironmentType are (none, open)."
  }
}
variable "ec2CpuCoreCount" {
  type    = number
  default = null
}
variable "ec2CpuThreadsPerCore" {
  type    = number
  default = null
}
variable "ec2CpuCredits" {
  type = string
  default = "standard"
}
variable "ec2DisableApiTermination" {
  type = bool
  default = false
}
variable "ec2EbsBlockDevices" {
  type        = list(map(string))
  default     = []
}
variable "isEbsOptimized" {
  type = bool
  default = null
}
variable "isEnclaveOptionEnabled" {
  type = bool
  default = false
}
variable "ec2EphemeralBlockDevice" {
  type        = list(map(string))
  default     = []
}
variable "ec2GetPasswordData" {
  type        = bool
  default     = null
}
variable "ec2IamInstanceProfile" {
  type        = string
  default     = null
}
variable "ec2MetadataOptions" {
  type        = map(string)
  default     = null
}
variable "isMonitoringEnabled" {
  type        = bool
  default     = false
}
variable "ec2NetworkInterface" {
  type        = list(map(string))
  default     = []
}
variable "ec2PlacementGroup" {
  type        = string
  default     = null
}
variable "ec2PrivateIp" {
  type        = string
  default     = null
}
variable "ec2RootBlockDevice" {
  type        = list(any)
  default     = []
}
variable "ec2SecondaryPrivateIps" {
  type        = list(string)
  default     = null
}
