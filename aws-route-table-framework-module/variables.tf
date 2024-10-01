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
variable "vpcId" {
  type = string
}
variable "name" {
  type = string
}
variable "isMainRtb" {
  type    = bool
  default = false
}
variable "ipv4Routes" {
  type    = list(map(string))
  default = []
}
variable "ipv6Routes" {
  type    = list(map(string))
  default = []
}
variable "prefixListRoutes" {
  type    = list(map(string))
  default = []
}
variable "subnets" {
  type    = list(string)
  default = []
}
variable "gateways" {
  type    = list(string)
  default = []
}
variable "propagatingVpnGateways" {
  type    = list(string)
  default = []
}
variable "vpcGatewayEndpoints" {
  type    = list(string)
  default = []
}
