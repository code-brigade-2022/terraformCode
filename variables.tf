# Variables del entorno
variable "teamName" {
  type        = string
  default     = "CodeBrigade"
  description = "nombre del proyecto para aplicar a los recursos asociados"
}

variable "appServicePlanPrefix" {
  type        = string
  default     = "plan-copa"
  description = "prefijo para app Service Plan"
}

variable "webappPrefix" {
  type        = string
  default     = "app-copa"
  description = "prefijo para web app"
}

variable "appInsightsPrefix" {
  type        = string
  default     = "appi-copa"
  description = "prefijo para application insigths"
}

variable "logAnalyticsPrefix" {
  type        = string
  default     = "log-copa"
  description = "prefijo para log analytics"
}

variable "location" {
  type    = string
  default = "South Central US"
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
