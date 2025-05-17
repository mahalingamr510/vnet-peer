terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "45a63a52-75a2-4412-b571-d9acdddbd403"
    tenant_id       = "5fd920e9-ff97-40f0-a8de-09b2f2610e35"
  features {}
}

resource "azurerm_resource_group" "rg_vnet1" {
  name     = "rg-vnet1"
  location = "East US"
}

resource "azurerm_resource_group" "rg_vnet2" {
  name     = "rg-vnet2"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = azurerm_resource_group.rg_vnet1.location
  resource_group_name = azurerm_resource_group.rg_vnet1.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2"
  location            = azurerm_resource_group.rg_vnet2.location
  resource_group_name = azurerm_resource_group.rg_vnet2.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_virtual_network_peering" "peering_vnet1_to_vnet2" {
  name                       = "vnet1-to-vnet2"
  resource_group_name        = azurerm_resource_group.rg_vnet1.name
  virtual_network_name       = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = false
  use_remote_gateways         = false
}

resource "azurerm_virtual_network_peering" "peering_vnet2_to_vnet1" {
  name                       = "vnet2-to-vnet1"
  resource_group_name        = azurerm_resource_group.rg_vnet2.name
  virtual_network_name       = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = false
  use_remote_gateways         = false
}
