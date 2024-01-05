resource "azurerm_resource_group" "app_grp_tf" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "functionstore10272023tf" {
  name                     = "functionstore10272023tf"
  resource_group_name      = azurerm_resource_group.app_grp_tf.name
  location                 = azurerm_resource_group.app_grp_tf.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "functionserviceplantf" {
  name                = "functionserviceplantf"
  location            = azurerm_resource_group.app_grp_tf.location
  resource_group_name = azurerm_resource_group.app_grp_tf.name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_function_app" "functionapp10272023tf" {
  name                = "functionapp10272023tf"
  location            = azurerm_resource_group.app_grp_tf.location
  resource_group_name = azurerm_resource_group.app_grp_tf.name
  service_plan_id     = azurerm_service_plan.functionserviceplantf.id
  storage_account_name       = azurerm_storage_account.functionstore10272023tf.name
  storage_account_access_key = azurerm_storage_account.functionstore10272023tf.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
}