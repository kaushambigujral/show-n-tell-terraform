variable "environment_name" {
  type        = string
  description = "The environment name, e.g. usc or uscpp"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name which contains the web app and plan"
}

variable "resource_group_location" {
  type        = string
  description = "The location of the web app resource, e.g. centralus"
}

variable "tags" {
  type = object({
    org_unit          = string
    product_domain    = string
    environment       = string
    environment_class = string
  })
}

variable "suffix_name" {
  type        = string
  description = "The suffix name of web app plan"
}

variable "extension_version" {
  type        = string
  description = "Runtime version associated with the Function App. "
  default     = "~4"
}

variable "sa_settings" {
  type = object({
    name               = string
    primary_access_key = string
  })
}

variable "func_app_settings" {
  type = map(any)
}

variable "app_plan_id" {
  type    = string
  default = null
}