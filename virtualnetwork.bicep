targetScope = 'resourceGroup' /* Not Needed as the default scope is resourceGroup. Using it as a reminder to set targetscope when needed.*/
var virtualNetwork = 'eastUS-vNet-Prod'
var location = resourceGroup().location
var nsgName = 'eastUS-vNSG-Prod'
resource vNet'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetwork
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ActiveDirectorySubnet'
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          defaultOutboundAccess: false
          networkSecurityGroup: {
             id:vNSG().id
          }
        }
      }
    ]
    }  
  }

  resource vNSG 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
    name: nsgName
    location: location
  }

