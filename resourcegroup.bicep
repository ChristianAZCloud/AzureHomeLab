targetScope = 'subscription'

resource resourcegroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'Homelab-RG'
  location: 'eastus'
  tags: {
  environment: 'prod'
  location: 'eastus'
  purpose: 'azure-to-onprem'
  owner: 'owner'
  deployedFrom: 'Bicep'
  }
}


