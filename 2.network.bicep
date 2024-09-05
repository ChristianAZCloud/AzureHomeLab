param environment string
var location = resourceGroup().location
param vNET string
param subnet string
param vnetcidrblock string
param subnetcidrblock string
param nsgName string
param defaultOutboundAccess bool

resource vNSG 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: '${location}-${nsgName}-${environment}'
  location: location
}

resource vNet'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vNET
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetcidrblock
      ]
    }
    subnets: [
      {
        name: subnet
        properties: {
          addressPrefixes: [
            subnetcidrblock
          ]
          defaultOutboundAccess: defaultOutboundAccess
          networkSecurityGroup: {
             id: vNSG.id
          }
        }
      }
    ]
    }  
  }

