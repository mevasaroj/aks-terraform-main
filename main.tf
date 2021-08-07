terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.5.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id 
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resourcename
  location = var.location
}

resource "azurerm_virtual_network" "k8s" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "k8s" {
  name                 = "aks-subnet"
  virtual_network_name = azurerm_virtual_network.k8s.name
  resource_group_name  = azurerm_resource_group.k8s.name
  address_prefix       = "10.1.0.0/22"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.clustername
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dnspreffix

default_node_pool {
    name       = "default"
    vnet_subnet_id = azurerm_subnet.k8s.id
    node_count = var.agentnode
    vm_size    = var.size
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2"]
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
  }


  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    network_policy     = "calico"
  }

service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}
