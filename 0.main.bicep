// Global Parameters 
param resourcetags object
param environment string
@allowed([
  'vNET'
  'VM'
  'keyVault'
])
param deploymodule string



// KeyVault Parameters 
param vaultName string
param keyvaultrg string
param enabledfortemplatedeployment bool
module keyVault '1.KeyVault.bicep' = if (deploymodule == 'keyVault'){
  name: vaultName
  scope: resourceGroup(keyvaultrg)
  params: {
   resourcetags: resourcetags
   vaultName: vaultName
   enabledfortemplatedeployment: enabledfortemplatedeployment
  }
}

// Virtual Network Parameters 
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
module virtualNetwork '2.network.bicep' = if (deploymodule == 'vNET') {
  name: vNET
  params: {
    vNET: vNET
    vnetcidrblock: vnetcidrblock
    subnet: subnet
    subnetcidrblock: subnetcidrblock
    nsgName: nsgName
    environment: environment
    defaultOutboundAccess: defaultOutboundAccess
    privateIPAddressVersion: privateIPAddressVersion
    privateIPAllocationMethod: privateIPAllocationMethod
    privateipconfig: privateipconfig
    publicipconfig: publicipconfig
    privateipaddress: privateipaddress
  }
}

// Virtual Machine Parameters 
param vmName string
@secure()
param adminPWD string
param adminUSER string
param bootDiagnosticsenabled bool
param deleteoption string
param vmSize string
module virtualMachine '3.activedirectory.bicep' = if (deploymodule == 'VM') {
  name: vmName
  params: {
    adminPWD: adminPWD
    adminUSER: adminUSER
    subnet: subnet
    privateIPAllocationMethod: privateIPAllocationMethod
    bootDiagnosticsenabled: bootDiagnosticsenabled
    environment: environment
    nsgName: nsgName
    deleteoption: deleteoption
    vmSize: vmSize
  }
}
