# Random suffix for globally unique names

resource "random_string" "func_suffix" {
  length  = 6
  upper   = false
  special = false
}


# Storage Account (required for Function App)

resource "azurerm_storage_account" "func_sa" {
  name                     = "stfunc${random_string.func_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Consumption Service Plan (Windows, Y1)

resource "azurerm_service_plan" "func_plan" {
  name                = "asp-func-${random_string.func_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  os_type  = "Windows"
  sku_name = "Y1"
}


# Windows Function App

resource "azurerm_windows_function_app" "func_app" {
  name                = "func-getvalue-${random_string.func_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  service_plan_id            = azurerm_service_plan.func_plan.id
  storage_account_name       = azurerm_storage_account.func_sa.name
  storage_account_access_key = azurerm_storage_account.func_sa.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"

    # Used by your C# Function code
    KEYVAULT_URI = azurerm_key_vault.kv.vault_uri
    SECRET_NAME  = "projectsecret"
  }
}


# RBAC: Function App can read Key Vault secrets

resource "azurerm_role_assignment" "func_kv_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_function_app.func_app.identity[0].principal_id
}
