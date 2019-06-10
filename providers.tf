# Configure the Azure Provider
variable azure_subscription_id {
     type = "string"
}
 
variable azure_client_id {
     type = "string"
}
 
variable azure_client_secret {
     type = "string"
}
 
variable azure_tenant_id {
     type = "string"
}

provider "azurerm" { 
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}