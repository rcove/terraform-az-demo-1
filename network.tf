##########################################
######### Management Template ############
##########################################

resource "azurerm_resource_group" "RG_network" {
  name     = "${var.project_name}-Network"
  location = "${var.location}"
}
# create the vnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-Labvnet"
  resource_group_name = "${azurerm_resource_group.RG_network.name}"
  address_space       = ["10.99.0.0/16"]
  location = "${var.location}"
}
# Create rt for DMZ1
resource "azurerm_route_table" "DMZ1RT" {
  name                = "DMZ1RT"
  location            = "${azurerm_resource_group.RG_network.location}"
  resource_group_name = "${azurerm_resource_group.RG_network.name}"

# segmentation 
  route {
    name           = "Internal"
    address_prefix = "10.99.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  # useg
  route {
    name           = "useg"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
}

  resource "azurerm_route_table" "DMZ2RT" {
  name                = "DMZ2RT"
  location            = "${azurerm_resource_group.RG_network.location}"
  resource_group_name = "${azurerm_resource_group.RG_network.name}"

  route {
    name           = "segment"
    address_prefix = "10.99.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  }
  
  resource "azurerm_route_table" "DMZ3RT" {
  name                = "DMZ3RT"
  location            = "${azurerm_resource_group.RG_network.location}"
  resource_group_name = "${azurerm_resource_group.RG_network.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
     next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "OnPrem"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "${var.gateway_int_ip}"
  }
  }  

  resource "azurerm_route_table" "GWRT" {
  name                = "GWRT"
  location            = "${azurerm_resource_group.RG_network.location}"
  resource_group_name = "${azurerm_resource_group.RG_network.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  }  

resource "azurerm_subnet" "External_subnet"  {
    name           = "External"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.0.0/24"
  }

resource "azurerm_subnet" "Gateway_subnet"  { 
    name           = "GatewaySubnet"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.100.0/24"
# route_table_id = "${azurerm_route_table.GWRT.id}"
  }
resource "azurerm_subnet_route_table_association" "rtgwrt" {
  subnet_id      = "${azurerm_subnet.Gateway_subnet.id}"
  route_table_id = "${azurerm_route_table.GWRT.id}"
}

resource "azurerm_subnet" "Internal_subnet"   {
    name           = "Internal"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.1.0/24"
  }
resource "azurerm_subnet" "DMZ1_subnet"  {
    name           = "DMZ1"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.11.0/24"
#	route_table_id = "${azurerm_route_table.DMZ1RT.id}"
  }
  resource "azurerm_subnet_route_table_association" "rtDMZ1rt" {
  subnet_id      = "${azurerm_subnet.DMZ1_subnet.id}"
  route_table_id = "${azurerm_route_table.GWRT.id}"
}

resource "azurerm_subnet" "DMZ2_subnet"  {
    name           = "DMZ2"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.12.0/24"
	route_table_id = "${azurerm_route_table.DMZ2RT.id}"
  }
resource "azurerm_subnet" "DMZ3_subnet" {
    name           = "DMZ3"
    resource_group_name  = "${azurerm_resource_group.RG_network.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.13.0/24"
	route_table_id = "${azurerm_route_table.DMZ3RT.id}"
  }

