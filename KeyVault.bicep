var vaultName = 'eastUS-keyVault-PROD'
var location = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: vaultName
  location: location
  properties: {
     enableRbacAuthorization: true
     enableSoftDelete: false
     networkAcls: {
       bypass: 'AzureServices'
       defaultAction: 'Deny'
     }
      enabledForDiskEncryption: true
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
  }
}
