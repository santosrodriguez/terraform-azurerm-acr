terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_string" "suffix" {
  length = 4
  numeric = true
  lower = false
  special = false
  upper = false
}

data "azurecaf_name" "acr_name" {
  resource_type = "azurerm_container_registry"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.suffix.result ]
}

resource "azurerm_container_registry" "acr" {
  location = var.location
  resource_group_name = var.resource_group_name
  name = data.azurecaf_name.acr_name.result
  sku = var.sku
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option = var.network_rule_bypass_option
  tags = var.tags
  zone_redundancy_enabled = var.zone_redundancy_enabled
  retention_policy_in_days = var.retention_policy_in_days
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "pep" {
  name = "pe-${azurerm_container_registry.acr.name}"
  location = azurerm_container_registry.acr.location
  resource_group_name = azurerm_container_registry.acr.resource_group_name
  subnet_id = var.private_endpoint_subnet_id
  private_service_connection {
    name = "pe-connection-${azurerm_container_registry.acr.name}"
    is_manual_connection = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names = [ "registry" ]
  }
  private_dns_zone_group {
    name = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_ids
  }
  depends_on = [ azurerm_container_registry.acr ]
}
