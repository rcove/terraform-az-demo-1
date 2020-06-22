##########################################
######### Gateway Template ############
##########################################

resource "azurerm_resource_group" "checkpoint_GW_ARM" {
  name     = "${var.project_name}-GW"
  location = var.location
}

resource "azurerm_template_deployment" "checkpoint_GW_ARM" {
  name                = "${var.project_name}-GW-template"
  resource_group_name = azurerm_resource_group.checkpoint_GW_ARM.name
  template_body       = file("gw_template/template.json")

  #    parameters = "${file("gw_template/parameters.json")}"
  depends_on      = [azurerm_virtual_network.vnet]
  deployment_mode = "Incremental"
}

