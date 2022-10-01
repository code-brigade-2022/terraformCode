# Variables del entorno
variable "teamName" {
  type        = string
  default     = "CodeBrigade"
  description = "nombre del proyecto para aplicar a los recursos asociados"
}

variable "location" {
  type    = string
  default = "East US 2"
}

variable "tags" {
  type = map(string)
  default = {
    "CREATEDBY" = "CodeBrigade"
    "DPT"       = "VENTAS"
    "AMBIENTE"  = "PRD"
  }
  description = "tags de los recursos"
}

variable "rgName" {
    type = string
    default = "RG-PROD-01"

}

variable "vnetSpace" {
    type = string
    default = "10.150.0.0/16"
}

variable "subnetSpace" {
  type = string
  default = "10.150.0.0/24"
}

variable "linuxPipName" {
  type = string
  default = "PIP-SRV-PROD-02-AZ"
  description = "nombre de la nic para linux"
}

variable "winPipName" {
  type = string
  default = "PIP-SRV-PROD-01-AZ"
  description = "nombre de la nic para windows server"
}

variable "linuxVMName" {
  type = string
  default = "SRV-PROD-02-AZ"
  description = "nombre de la VM para linux"
}

variable "winVMName" {
  type = string
  default = "SRV-PROD-01-AZ"
  description = "nombre de la VM para windows server"
}

# variable "appServicePlanPrefix" {
#   type        = string
#   default     = "plan-copa"
#   description = "prefijo para app Service Plan"
# }
#
# variable "webappPrefix" {
#   type        = string
#   default     = "app-copa"
#   description = "prefijo para web app"
# }
#
# variable "appInsightsPrefix" {
#   type        = string
#   default     = "appi-copa"
#   description = "prefijo para application insigths"
# }
#
# variable "logAnalyticsPrefix" {
#   type        = string
#   default     = "log-copa"
#   description = "prefijo para log analytics"
# }
#
