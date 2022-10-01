# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used

# RG
resource "azurerm_resource_group" "rg" {
  name     = "RG-${var.teamName}"
  location = var.location
  tags     = var.tags
}
# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.appServicePlanPrefix}-${var.teamName}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
  tags = var.tags
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "${var.webappPrefix}-${var.teamName}-01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config {
    minimum_tls_version = "1.2"
  }
  tags = var.tags
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/code-brigade-2022/CopaReto1.git"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}


# Application log analytics
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.logAnalyticsPrefix}-${var.teamName}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = var.tags
}

resource "azurerm_application_insights" "example" {
  name                = "${var.appInsightsPrefix}-${var.teamName}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = "web"
  tags = var.tags
}
