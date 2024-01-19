resource "azurerm_resource_group" "servicebus-rg" {
  name     = "servicebus-rg"
  location = "West US"
}

resource "azurerm_servicebus_namespace" "servicebus-namespace" {
  name                = "servicebus-namespace-kg"
  location            = azurerm_resource_group.servicebus-rg.location
  resource_group_name = azurerm_resource_group.servicebus-rg.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
    author = "Kaushambi Gujral"
  }
}

resource "azurerm_servicebus_topic" "servicebus-topic" {
  name         = "servicebus_topic_kg"
  namespace_id = azurerm_servicebus_namespace.servicebus-namespace.id
}


resource "azurerm_servicebus_subscription" "servicebus-subscription" {
  name               = "servicebus_subscription_kg"
  topic_id           = azurerm_servicebus_topic.servicebus-topic.id
  max_delivery_count = 5
}