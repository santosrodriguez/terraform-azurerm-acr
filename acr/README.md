# Azure Container Registry Terraform Module

## Introduction
This module deploys an Azure Container Registry with a private endpoint and diagnostic settings.

## Usage

```hcl
module "acr" {
  source = "caresource.pe.jfrog.io/shared-tfmodules-internal__container/acr/azurerm"
  version = "0.1.0"
  environment = var.environment
  private_endpoint_subnet_id = "/subscriptions/../resourceGroups/../providers/Microsoft.Network/virtualNetworks/../subnets/.."
  resource_group_name = var.resource_group_name
  sku = var.sku
  solution_name = var.solution_name
}
```

## Inputs
| Name                                | Type           | Description                                        | Default    |
|--------------------------------------|----------------|----------------------------------------------------|------------|
| environment                          | string         | The environment name (e.g. dev, test, prod), used in resource naming. | n/a |
| private_endpoint_subnet_id           | string         | The subnet ID where the private endpoint for the container registry will be created. | n/a |
| resource_group_name                  | string         | The name of the resource group in which to deploy the container registry. | n/a |
| sku                                   | string         | The SKU of the container registry. Valid values are Basic, Standard, or Premium. | n/a |
| solution_name                        | string         | The name of the solution, used in resource naming. | n/a |

## Outputs
| Name                                  | Description                              |
|-----------------------------------------|-------------------------------------------|
| acr                                      | The full azurerm_container_registry resource object for the created container registry. |

## Features

- Creates an Azure Container Registry with a system-assigned managed identity
- Standardizes the registry name using the azurecaf provider naming convention
- Deploys a private endpoint for the registry with a configurable private DNS zone group
- Configures diagnostic settings that forward logs to an Event Hub

## Requirements

- Terraform >= 1.4.0
- AzureRM >= 3.0
