param environment string
param location  string = resourceGroup().location
param vNET string
param subnet string
param vnetcidrblock string
param subnetcidrblock string
param nsgName string
param defaultOutboundAccess bool
param privateIPAddressVersion string
param privateipconfig string
param publicipconfig string
param privateipaddress string
param privateIPAllocationMethod string


resource vNSG 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${location}-${nsgName}-${environment}'
  location: location
}


resource vNet'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vNET
  location: location
  properties: {
    addressSpace: {
      addressPrefixes:[ vnetcidrblock
      ]
      
    }
    subnets: [
      {
        name: subnet
        properties: {
          addressPrefix: subnetcidrblock
          defaultOutboundAccess: defaultOutboundAccess
          networkSecurityGroup: {
             id: vNSG.id
          }
        }
      }
    ]
    }  
  }
  
resource networkinterface 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'aduceastus'
  location: location
  properties: {
   ipConfigurations: [
     {
       name: privateipconfig
       properties: {
         privateIPAddressVersion: privateIPAddressVersion
         privateIPAllocationMethod: privateIPAllocationMethod
          privateIPAddress: privateipaddress
         subnet: {
          id: '${vNet.id}/subnets/${subnet}'
        }        
       }
     }
   ]
  
  }
}
