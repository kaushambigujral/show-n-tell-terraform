variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "resource_group_location" {
  default     = "West US"
  description = "Location of the resource group."
}

variable "environment"{
  default = "development"
  description = "Name of the environment"
}

variable "environment_class"{
  default = "dev"
  description = "Class Name of the environment"
}

variable "cis_topic_connstr"{
  description = "Connection String"
}

variable "cis_topic"{
  description = "Topic"
}

variable "cis_subscription"{
  description = "Subscription"
}