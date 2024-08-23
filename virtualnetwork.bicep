targetScope = 'resourceGroup' /* Not Needed as the default scope is resourceGroup. Using it as a reminder to set targetscope when needed.*/
var virtualNetwork = 'eastUS-vNet-Prod'
var location = resourceGroup().location

resource vNet'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetwork
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/8'
      ]
    }
    subnets: [
      {
        name: 'ActiveDirectorySubnet'
        properties: {
          addressPrefixes: [
            '10.1.127.0'
          ]
          defaultOutboundAccess: false
        }
      }
    ]
    }  
  }

