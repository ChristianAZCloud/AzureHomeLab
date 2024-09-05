param resourcetags object
param environment string

param vaultName string
param enabledfortemplatedeployment bool
module keyVault '1.KeyVault.bicep' = {
  name: vaultName
  params: {
   resourcetags: resourcetags
   vaultName: vaultName
   enabledfortemplatedeployment: enabledfortemplatedeployment
  }
}

param vNET string
param subnet string
param vnetcidrblock string
param subnetcidrblock string
param nsgName string
param defaultOutboundAccess bool
module virtualNetwork '2.network.bicep' = {
  name: vNET
  params: {
    vNET: vNET
    vnetcidrblock: vnetcidrblock
    subnet: subnet
    subnetcidrblock: subnetcidrblock
    nsgName: nsgName
    environment: environment
    defaultOutboundAccess: defaultOutboundAccess
  }
}
