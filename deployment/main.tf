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

  app_settings = {
    MY_ENV_VAR = "my-env-var-value"
  }

  site_config {
    always_on = true
    app_command_line = "bundle exec puma -C config/puma.rb"
    worker_count = 1

    application_stack {
      ruby_version = "2.7"
    }
  }
}
