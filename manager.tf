##########################################
######### Management Template ############
##########################################

resource "azurerm_resource_group" "checkpoint_Management_ARM" {
  name     = "${var.project_name}-Management"
  location = var.location
}

resource "azurerm_template_deployment" "checkpoint_Management_ARM" {
  name                = "${var.project_name}-Mgr-template"
  resource_group_name = azurerm_resource_group.checkpoint_Management_ARM.name
  template_body       = file("manager_r8020_template/template.json")

  #    parameters = "${file("manager_r8020_template/parameters.json")}"
  depends_on      = [azurerm_virtual_network.vnet]
  deployment_mode = "Incremental"
}

