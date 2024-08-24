var vaultName = 'eastUS-keyVault-PROD'
var location = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: vaultName
  location: location
  properties: {
     enabledForDeployment: true
     enabledForDiskEncryption: true
     enabledForTemplateDeployment: true
     enableRbacAuthorization: true
     enableSoftDelete: false
     networkAcls: {
       bypass: 'None'
       defaultAction: 'Deny'
     }
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
  }
}
