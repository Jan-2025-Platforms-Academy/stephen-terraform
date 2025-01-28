## Create Public VMs

# Create Public IPs
resource "azurerm_public_ip" "this" {
  count               = 3
  name                = "${var.team_name}-public-vm-${count.index}-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"

  tags = {
    team = var.team_name
  }
}

# Create Public NICs
resource "azurerm_network_interface" "public" {
  count               = 3
  name                = "${var.team_name}-public-vm-${count.index}-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "${var.team_name}-nic-config"
    subnet_id                     = azurerm_subnet.public[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[count.index].id
  }

  tags = {
    team = var.team_name
  }
}

# Create Public Security Group
resource "azurerm_network_security_group" "public" {
  name                = "${var.team_name}-public-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    team = var.team_name
  }
}

# Associate Security Group with NIC
resource "azurerm_network_interface_security_group_association" "public" {
  for_each = {
    for idx, nic in azurerm_network_interface.public :
    idx => nic.id
  }

  network_interface_id      = each.value
  network_security_group_id = azurerm_network_security_group.public.id
}

# Create Public VM
resource "azurerm_linux_virtual_machine" "public" {
  count               = 3
  name                = "${var.team_name}-public-vm-${count.index}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.public[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_key_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    team = var.team_name
  }
}




## Create Private VMs

# Create Private NICs
resource "azurerm_network_interface" "private" {
  count               = 3
  name                = "${var.team_name}-private-vm-${count.index}-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "${var.team_name}-nic-config"
    subnet_id                     = azurerm_subnet.private[count.index].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    team = var.team_name
  }
}

# Create Public Security Group
resource "azurerm_network_security_group" "private" {
  name                = "${var.team_name}-private-nsg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    team = var.team_name
  }
}

# Associate Security Group with NIC
resource "azurerm_network_interface_security_group_association" "private" {
  for_each = {
    for idx, nic in azurerm_network_interface.private :
    idx => nic.id
  }

  network_interface_id      = each.value
  network_security_group_id = azurerm_network_security_group.private.id
}

# Create Private VM
resource "azurerm_linux_virtual_machine" "private" {
  count               = 3
  name                = "${var.team_name}-private-vm-${count.index}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.private[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    team = var.team_name
  }
}
