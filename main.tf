# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG-tfState"
    storage_account_name = "tfstate30576"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
        features {}
         subscription_id   = "7703a13e-c5e9-4503-88de-6a4892b0b3c7"
         tenant_id         = "f07b40ae-b60b-4e0f-bebe-afb42fc4dc69"
         client_id         = "df3cc47a-20cd-44c1-9255-cfc9d8ae6d2c"
         client_secret     = "nf-LJPAqQq~78kNEKz7cir7woLPTOJ-pWP"
}

# VM
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
  repo_url           = "https://github.com/iukion/CopaHackathon_html_base.git"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}
