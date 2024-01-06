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

resource "azurerm_application_insights" "odfl_relay_app_insights" {
  name                   = "odfl-relay-app-insights-${var.environment}"
  resource_group_name    = azurerm_resource_group.app_grp_tf.name
  location               = azurerm_resource_group.app_grp_tf.location
  application_type       = "web"
  
  depends_on = [
    azurerm_service_plan.functionserviceplantf
  ]
}
locals{
  resource_tags = {
    org_unit          = "ODFL RELAY"
    product_domain    = "ODFL Product Domain"
    environment       = var.environment
    environment_class = var.environment == "production" ? "prod" : "dev"
  }
}

# Create multiple relay apps
module "func-odfl-relay-commands"{
  source                  = "./modules/func-app"
  tags                    = local.resource_tags
  resource_group_name     = azurerm_resource_group.app_grp_tf.name
  resource_group_location = azurerm_resource_group.app_grp_tf.location
  environment_name        = var.environment == "production" ? "p" : "np" 
  suffix_name             = "commands"
  app_plan_id             = azurerm_service_plan.functionserviceplantf.id
  extension_version       = "~4"
  depends_on = [
    azurerm_service_plan.functionserviceplantf
  ]
  sa_settings = {
    name                  = azurerm_storage_account.functionstore10272023tf.name
    primary_access_key    = azurerm_storage_account.functionstore10272023tf.primary_access_key
  }
  func_app_settings =  {
    "OperationTimeoutSecond": 30,
    "environment": var.environment == "production" ? "p" : "np" ,
    "FUNCTION_APP_EDIT_MODE" : "readwrite",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.odfl_relay_app_insights.instrumentation_key}"
    "CIS_TOPIC_CONNSTR": var.cis_topic_connstr,
    "CIS_TOPIC_NAME": var.cis_topic,
    "CIS_SUBSCRIPTION_NAME":  var.cis_subscription
  }
}


module "func-odfl-relay-duty-status"{
  source                  = "./modules/func-app"
  tags                    = local.resource_tags
  resource_group_name     = azurerm_resource_group.app_grp_tf.name
  resource_group_location = azurerm_resource_group.app_grp_tf.location
  environment_name        = var.environment == "production" ? "p" : "np" 
  suffix_name             = "duty-status"
  app_plan_id             = azurerm_service_plan.functionserviceplantf.id
  extension_version       = "~4"
  depends_on = [
    azurerm_service_plan.functionserviceplantf
  ]
  sa_settings = {
    name                  = azurerm_storage_account.functionstore10272023tf.name
    primary_access_key    = azurerm_storage_account.functionstore10272023tf.primary_access_key
  }
  func_app_settings =  {
    "OperationTimeoutSecond": 30,
    "environment": var.environment == "production" ? "p" : "np" ,
    "FUNCTION_APP_EDIT_MODE" : "readwrite",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.odfl_relay_app_insights.instrumentation_key}"
    "CIS_TOPIC_CONNSTR": var.cis_topic_connstr,
    "CIS_TOPIC_NAME": var.cis_topic,
    "CIS_SUBSCRIPTION_NAME":  var.cis_subscription
  }
}

