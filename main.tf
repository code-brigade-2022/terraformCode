# grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.rgName
  location = var.location
  tags = var.tags
}
resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-PROD"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = azurerm_resource_group.rg.tags
  address_space       = ["${var.vnetSpace}"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "Subnet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["${var.subnetSpace}"]
}

resource "azurerm_network_security_group" "sg" {
  name                = "SG-PROD-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  description = "puerto para conexion SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "HTTP"
  description = "puerto para conexion HTTP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}


resource "azurerm_network_security_rule" "rdp" {
  name                        = "RDP"
  description = "puerto para conexion SSH"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}
resource "azurerm_subnet_network_security_group_association" "SGA" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

resource "azurerm_public_ip" "linuxPIP" {
  name                = var.linuxPipName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_network_interface" "linux-nic" {
  name                = "nic-${var.linuxPipName}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linuxPIP.id
  }
  tags = azurerm_resource_group.rg.tags
}

resource "azurerm_public_ip" "winPIP" {
  name                = var.winPipName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_network_interface" "win-nic" {
  name                = "nic-${var.winPipName}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.winPIP.id
  }
  tags = azurerm_resource_group.rg.tags
}
# Maquina Virtual Linux
resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.linuxVMName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"

  admin_username      = "codebrigade"
  computer_name       = "linuxvm"
  admin_password      = "hackaton2022COPA"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.linux-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = "60"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
    tags = var.tags
}

# Maquina Virtual Windows Server

resource "azurerm_windows_virtual_machine" "winvm" {
  name                = var.winVMName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "codebrigade"
  admin_password      = "hackaton2022COPA"
  network_interface_ids = [
    azurerm_network_interface.win-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = "128"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
