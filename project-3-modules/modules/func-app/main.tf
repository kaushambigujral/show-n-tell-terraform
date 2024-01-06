# Create Azure Functions
resource "azurerm_windows_function_app" "func-app" {
  name                = "${var.environment_name}-odfl-relay-${var.suffix_name}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  storage_account_name       = var.sa_settings.name
  storage_account_access_key = var.sa_settings.primary_access_key
  service_plan_id            = var.app_plan_id
  app_settings = var.func_app_settings
  functions_extension_version = var.extension_version

  site_config {}
}
