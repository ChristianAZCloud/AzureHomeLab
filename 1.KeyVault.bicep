param vaultName string
var location = resourceGroup().location
param resourcetags object
param enabledfortemplatedeployment bool

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  tags: resourcetags
  properties: {
     enableRbacAuthorization: true
     enableSoftDelete: false
     enabledForTemplateDeployment: enabledfortemplatedeployment
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

