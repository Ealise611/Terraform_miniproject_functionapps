resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.key_vault_soft_delete_retention_days
  purge_protection_enabled    = false

  sku_name = "standard"

  enable_rbac_authorization = true
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "demo-secret"
  value        = var.key_vault_secret_value
  key_vault_id = azurerm_key_vault.kv.id
}
