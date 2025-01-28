## Create Virtual Networks

# Create Public VNet
resource "azurerm_virtual_network" "public" {
  name                = "${var.team_name}-public-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    team = var.team_name
  }
}

resource "azurerm_subnet" "public" {
  count                = 3
  name                 = "${var.team_name}-public-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}


# Create Private VNet
resource "azurerm_virtual_network" "private" {
  name                = "${var.team_name}-private-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.1.0.0/16"]

  tags = {
    team = var.team_name
  }
}

resource "azurerm_subnet" "private" {
  count                = 3
  name                 = "${var.team_name}-private-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.private.name
  address_prefixes     = ["10.1.${count.index}.0/24"]
}


# Ceate VNet Peering
resource "azurerm_virtual_network_peering" "public-to-private-peering" {
  name                      = "${var.team_name}-public-to-private-peering"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.public.name
  remote_virtual_network_id = azurerm_virtual_network.private.id
}

resource "azurerm_virtual_network_peering" "private-to-public-peering" {
  name                      = "${var.team_name}-private-to-public-peering"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.private.name
  remote_virtual_network_id = azurerm_virtual_network.public.id
}
