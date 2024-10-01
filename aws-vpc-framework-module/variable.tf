variable "CUSTOMER" {
    type = string
}
variable "EnvironmentType" {
    type = string
    default = "DEV"
    
    validation {
      condition = contains(["PRD","QAS","DEV","TST","POC","BKP","DMO","SND"], var.EnvironmentType)
      error_message = "Valid values for var: EnvironmentType are (PRD,QAS,DEV,TST,POC,BKP,DMO,SND)."
    }
}
variable "Application" {
    type = string
}
variable "Purpose" {
    type = string

    validation {
      condition = contains(["WAP","WEB","APP","RDB","ETL","DAM","MDL","BUS","API","NET"], var.Purpose)
      error_message = "Valid values for var: EnvironmentType are (WAP,WEB,APP,RDB,ETL,DAM,MDL,BUS,API,NET)."
    }
}
variable "OwnerEmail" {
    type = string
}
variable "vpc_cidr_block" {
    type = string
}
variable "enable_dns_support" {
    type = bool
    default = true
}
variable "enable_dns_hostnames" {
    type = bool
    default = true
}
variable "instance_tenancy" {
    type = string
    default = "default"

    validation {
      condition = contains(["default","dedicated", "host"], var.instance_tenancy)
      error_message = "Valid values for var: instance_tenancy are (default, dedicated, host)."
    }
}
variable "tags" {
    type = map
    default = {}
}