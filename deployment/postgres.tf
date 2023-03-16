resource "azurerm_postgresql_server" "my_zivi" {
  location                = data.azurerm_resource_group.my_zivi.location
  name                    = "my-zivi-${var.app_postfix}"
  resource_group_name     = data.azurerm_resource_group.my_zivi.name
  sku_name                = "B_Gen5_1"
  ssl_enforcement_enabled = true
  version                 = "11"

  administrator_login          = var.postgres_admin_login
  administrator_login_password = var.postgres_admin_password
}

resource "azurerm_postgresql_database" "my_zivi" {
  charset             = "UTF8"
  collation           = "de_DE"
  name                = "my-zivi-${var.app_postfix}"
  resource_group_name = data.azurerm_resource_group.my_zivi.name
  server_name         = azurerm_postgresql_server.my_zivi.name
}
