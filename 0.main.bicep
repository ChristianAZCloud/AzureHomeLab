// Global Parameters 
param resourcetags object
param environment string
@allowed([
  'vNET'
  'VM'
  'keyVault'
  'SCCM'
  'SQL'
])
param deploymodule string



// KeyVault Parameters 
param vaultName string
param keyvaultrg string
param enabledfortemplatedeployment bool
//

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
param vnetcidrblock string
param activedirectorysubnetPrefix string
param defaultOutboundAccess bool
//resource vmnetworkinterface
param privateIPAddressVersion string
param privateipconfig string
param privateipaddress string
param privateIPAllocationMethod string
param enableIPForwarding bool
//
param publicipsku object
param publicIPAddressVersion string
param publicIPAllocationMethod string
param gatewayType string
param vpnGatewayGeneration string
param gatewaySku object
param activeActive bool
param gtwyaddressPrefix string
@secure()
param localgatewayIpAddress string
param localgatewayaddressPrefixes array
@secure()
param authorizationKey string
param vpntype string
param ipsecPolicies array
param connectionType string
param connectionMode string
param connectionProtocol string
param enablePrivateIpAddress bool
param dpdTimeoutSeconds int
param deployvpngtwy bool
param useLocalAzureIpAddress bool
param sccmsubnetprefix string
param sqlsvrsubnetprefix string
param sccmipaddress string
param sqlsvripaddress string
//
module virtualNetwork '2.network.bicep' = if (deploymodule == 'vNET') {
  name: vNET
  params: {
    vnetcidrblock: vnetcidrblock
    activedirectorysubnetPrefix: activedirectorysubnetPrefix
    environment: environment
    defaultOutboundAccess: defaultOutboundAccess
    privateIPAddressVersion: privateIPAddressVersion
    privateIPAllocationMethod: privateIPAllocationMethod
    privateipconfig: privateipconfig
    privateipaddress: privateipaddress
    publicipsku: publicipsku
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    gatewaySku: gatewaySku
    gatewayType: gatewayType
    vpnGatewayGeneration: vpnGatewayGeneration
    activeActive: activeActive
    gtwyaddressPrefix: gtwyaddressPrefix
    localgatewayIpAddress: localgatewayIpAddress
    localgatewayaddressPrefixes: localgatewayaddressPrefixes
    authorizationKey: authorizationKey
    vpntype: vpntype
    connectionType: connectionType
    ipsecPolicies: ipsecPolicies
    connectionMode: connectionMode
    connectionProtocol: connectionProtocol
    resourcetags: resourcetags
    enablePrivateIpAddress: enablePrivateIpAddress
    dpdTimeoutSeconds: dpdTimeoutSeconds
    enableIPForwarding: enableIPForwarding
    deployvpngtwy: deployvpngtwy
    useLocalAzureIpAddress: useLocalAzureIpAddress
    sccmsubnetprefix: sccmsubnetprefix
    sqlsvrsubnetprfix: sqlsvrsubnetprefix
    sccmipaddress: sccmipaddress
    sqlsvripaddress: sqlsvripaddress
  }
}

// Virtual Machine Parameters 
param vmNamePrefix string
@secure()
param adminPWD string
param adminUSER string
param bootDiagnosticsenabled bool
param deleteoption string
param vmSize string
param imagereference object 
param diskSizeGB int
//
module virtualMachine '3.activedirectory.bicep' = if (deploymodule == 'VM') {
  name: vmNamePrefix
  params: {
    adminPWD: adminPWD
    adminUSER: adminUSER
    bootDiagnosticsenabled: bootDiagnosticsenabled
    deleteoption: deleteoption
    vmSize: vmSize
    imagereference: imagereference
    environment: environment     
    diskSizeGB: diskSizeGB
  }
}

module sccmVM '4.sccmserver.bicep' = if (deploymodule == 'SCCM') {
  name: 'sccmVM'
  params: {
    adminPWD: adminPWD
    adminUSER: adminUSER
    bootDiagnosticsenabled: bootDiagnosticsenabled
    deleteoption: deleteoption
    diskSizeGB: diskSizeGB
    environment: environment
    imagereference: imagereference
    vmSize: vmSize
  }
  
}

param sqlvmSize string
module sqlsvrVM '5.sqlserver.bicep' = if (deploymodule == 'SQL') {
  name: 'sqlsvrVM'
  params: {
    adminPWD: adminPWD
    adminUSER: adminUSER
    bootDiagnosticsenabled: bootDiagnosticsenabled
    deleteoption: deleteoption
    diskSizeGB: diskSizeGB
    environment: environment
    imagereference: imagereference
    sqlvmSize: sqlvmSize
  }
}
