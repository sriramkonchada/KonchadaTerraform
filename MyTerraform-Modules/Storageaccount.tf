provider "azurerm" {
  features {}
}

data "azurerm_client_config" "example" {

}

resource "azurerm_resource_group" "examplers" {
  name     = "exrssrivi"
  location = "West Europe"
}

resource "azurerm_storage_account" "examplesa" {
  name                     = "exsasrivi"
  resource_group_name      = azurerm_resource_group.examplers.name
  location                 = azurerm_resource_group.examplers.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = "true"
  allow_nested_items_to_be_public = "false"
  
   blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
     days = 7
    }
	}
   routing {
    choice = "MicrosoftRouting"
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_role_assignment" "sa" {
  scope                = azurerm_storage_account.examplesa.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.example.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "examplesadlgenfs" {
  depends_on         = [azurerm_role_assignment.sa]
  name               = "exsadlfssrivi"
  storage_account_id = azurerm_storage_account.examplesa.id
}



