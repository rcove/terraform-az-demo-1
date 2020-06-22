/* create a protected vnet with segmented 
subnets in azure 
Richard Cove rcove@checkpoint.com
Ryan Darst
*/
resource "azurerm_resource_group" "server" {
  name     = "${var.project_name}-server"
  location = var.location
}

# Ubuntu DMZ1 interface  
resource "azurerm_network_interface" "ubuntuDMZ1" {
  name                 = "ubuntuDMZ1"
  location             = azurerm_resource_group.server.location
  resource_group_name  = azurerm_resource_group.server.name
  enable_ip_forwarding = "false"
  ip_configuration {
    name                          = "ubuntuDMZ1Configuration"
    subnet_id                     = azurerm_subnet.DMZ1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Ubuntu DMZ2a interface  
resource "azurerm_network_interface" "ubuntuDMZ2" {
  name                 = "ubuntuDMZ2"
  location             = azurerm_resource_group.server.location
  resource_group_name  = azurerm_resource_group.server.name
  enable_ip_forwarding = "false"
  ip_configuration {
    name                          = "ubuntuDMZ2Configuration"
    subnet_id                     = azurerm_subnet.DMZ2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Ubuntu DMZ2b interface  
resource "azurerm_network_interface" "ubuntuDMZ2b" {
  name                 = "ubuntuDMZ2b"
  location             = azurerm_resource_group.server.location
  resource_group_name  = azurerm_resource_group.server.name
  enable_ip_forwarding = "false"
  ip_configuration {
    name                          = "ubuntuDMZ2bConfiguration"
    subnet_id                     = azurerm_subnet.DMZ2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Ubuntu DMZ3a interface  
resource "azurerm_network_interface" "ubuntuDMZ3a" {
  name                 = "ubuntuDMZ3a"
  location             = azurerm_resource_group.server.location
  resource_group_name  = azurerm_resource_group.server.name
  enable_ip_forwarding = "false"
  ip_configuration {
    name                          = "ubuntuDMZ3aConfiguration"
    subnet_id                     = azurerm_subnet.DMZ3_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Ubuntu DMZ3b interface  
resource "azurerm_network_interface" "ubuntuDMZ3b" {
  name                 = "ubuntuDMZ3b"
  location             = azurerm_resource_group.server.location
  resource_group_name  = azurerm_resource_group.server.name
  enable_ip_forwarding = "false"
  ip_configuration {
    name                          = "ubuntuDMZ3bConfiguration"
    subnet_id                     = azurerm_subnet.DMZ3_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.server.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.server.name
  location                 = azurerm_resource_group.server.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# linux      
resource "azurerm_virtual_machine" "ubuntudmz1" {
  name                  = "ubuntudmz1"
  location              = azurerm_resource_group.server.location
  resource_group_name   = azurerm_resource_group.server.name
  network_interface_ids = [azurerm_network_interface.ubuntuDMZ1.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "ubuntudmz1disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.project_name}-dmz1"
    admin_username = var.vm_username
    admin_password = var.vm_password
    custom_data    = var.Linux_user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = var.Demo_tag
  }
}

resource "azurerm_virtual_machine" "ubuntudmz2" {
  name                  = "ubuntudmz2"
  location              = azurerm_resource_group.server.location
  resource_group_name   = azurerm_resource_group.server.name
  network_interface_ids = [azurerm_network_interface.ubuntuDMZ2.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "ubuntudmz2disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.project_name}-dmz2"
    admin_username = var.vm_username
    admin_password = var.vm_password
    custom_data    = var.Linux_user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = var.Demo_tag
  }
}

resource "azurerm_virtual_machine" "ubuntudmz2b" {
  name                  = "ubuntudmz2b"
  location              = azurerm_resource_group.server.location
  resource_group_name   = azurerm_resource_group.server.name
  network_interface_ids = [azurerm_network_interface.ubuntuDMZ2b.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "ubuntudmz2bdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.project_name}-dmz2b"
    admin_username = var.vm_username
    admin_password = var.vm_password
    custom_data    = var.Linux_user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = var.Demo_tag
  }
}

resource "azurerm_virtual_machine" "ubuntudmz3a" {
  name                  = "ubuntudmz3a"
  location              = azurerm_resource_group.server.location
  resource_group_name   = azurerm_resource_group.server.name
  network_interface_ids = [azurerm_network_interface.ubuntuDMZ3a.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "ubuntudmz3adisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.project_name}-dmz3a"
    admin_username = var.vm_username
    admin_password = var.vm_password
    custom_data    = var.Linux_user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = var.Demo_tag
  }
}

resource "azurerm_virtual_machine" "ubuntudmz3b" {
  name                  = "ubuntudmz3b"
  location              = azurerm_resource_group.server.location
  resource_group_name   = azurerm_resource_group.server.name
  network_interface_ids = [azurerm_network_interface.ubuntuDMZ3b.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "ubuntudmz3bdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.project_name}-dmz3a"
    admin_username = var.vm_username
    admin_password = var.vm_password
    custom_data    = var.Linux_user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
  tags = {
    environment = var.Demo_tag
  }
}

