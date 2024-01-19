resource "azurerm_resource_group" "kglearning" {
  name = "kg-learning"
  location = "West US 2"
}

resource "azurerm_servicebus_namespace" "azure_functions_messaging" {
  name                = "azure-function-messaging"
  location            = azurerm_resource_group.kglearning.location
  resource_group_name = azurerm_resource_group.kglearning.name
  sku                 = "Standard"

  tags = {
    project: "function-apps" # these tags are same as what's on azure because I wanted to have the exact same resource here
  }
}

resource "azurerm_servicebus_topic" "topic" {
  name         = "topic-1"
  namespace_id = azurerm_servicebus_namespace.azure_functions_messaging.id
  enable_batched_operations = true
}


# terraform import azurerm_resource_group.kglearning /subscriptions/06e10652-1077-4f95-bbfc-2b39226e13a0/resourceGroups/kg-learning
# terraform import azurerm_servicebus_namespace.azure_functions_messaging /subscriptions/06e10652-1077-4f95-bbfc-2b39226e13a0/resourceGroups/kg-learning/providers/Microsoft.ServiceBus/namespaces/azure-function-messaging
# terraform import azurerm_servicebus_topic.topic /subscriptions/06e10652-1077-4f95-bbfc-2b39226e13a0/resourceGroups/kg-learning/providers/Microsoft.ServiceBus/namespaces/azure-function-messaging/topics/topic-1