param resourcetags object
param environment string

param vaultName string
param keyvaultrg string
param enabledfortemplatedeployment bool
module keyVault '1.KeyVault.bicep' = {
  name: vaultName
  scope: resourceGroup(keyvaultrg)
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

param existingNSG string


param vmName string
@secure()
param adminPWD string
param adminUSER string
param vNIC string
module virtualMachine '3.activedirectory.bicep' = {
  name: vmName
  params: {
    adminPWD: adminPWD
    adminUSER: adminUSER
    vmName: vmName
    vNIC: vNIC
    existingNSG: existingNSG
  }
}
