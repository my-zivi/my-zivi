### Provider Setup

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

## Variables

variable "app_postfix" {
  type = string
  validation {
    condition     = length(var.app_postfix) > 0
    error_message = "The postfix must be at least 1 character long."
  }
}

data "azurerm_resource_group" "my_zivi" {
  name = "my-zivi"
}

resource "azurerm_service_plan" "my_zivi" {
  name                = "my-zivi-${var.app_postfix}-plan"
  location            = data.azurerm_resource_group.my_zivi.location
  resource_group_name = data.azurerm_resource_group.my_zivi.name

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "my-zivi" {
  location            = data.azurerm_resource_group.my_zivi.location
  name                = "my-zivi-${var.app_postfix}"
  resource_group_name = data.azurerm_resource_group.my_zivi.name
  service_plan_id     = azurerm_service_plan.my_zivi.id

  site_config {
    always_on = true
    app_command_line = "bundle exec puma -C config/puma.rb"
    worker_count = 1

    application_stack {
      ruby_version = "2.7"
    }
  }
}

### PostgreSQL

resource "azurerm_postgresql_server" "my_zivi" {
  location                = data.azurerm_resource_group.my_zivi.location
  name                    = "my-zivi-${var.app_postfix}"
  resource_group_name     = data.azurerm_resource_group.my_zivi.name
  sku_name                = "B_Gen5_1"
  ssl_enforcement_enabled = false
  version                 = "11"
}

resource "azurerm_postgresql_database" "my_zivi" {
  charset             = ""
  collation           = ""
  name                = "my-zivi-${var.app_postfix}"
  resource_group_name = data.azurerm_resource_group.my_zivi.name
  server_name         = azurerm_postgresql_server.my_zivi.name
}
