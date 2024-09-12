param environment string
param location  string = resourceGroup().location
param resourcetags object

var vpnGTWYName = 'onpremvpngtwy'
var aducNSGName = 'aducNSG'
var gtwyNSG2Name = '${vpnGTWYName}NSG'
var vNETName = 'virtualnetwork'
var publicipName = '${vpnGTWYName}-publicip'
var aducnetworkinterfaceName = 'aducNIC'
var localnetworkgtwyName = 'onpremlocalgtwy'
var connectionName = 'azure-to-onprem'
var routetableName = 'routetable'
resource aducNSG 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${aducNSGName}-${environment}'
  location: location
}

resource gtwyNSG 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${gtwyNSG2Name}-${environment}'
  location: location
}

param vnetcidrblock string
resource vNet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: '${vNETName}-${environment}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes:[ vnetcidrblock
      ]
    }
          }
 }

param activedirectorysubnetPrefix string
param defaultOutboundAccess bool
resource activedirectorysubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
    name: 'ActiveDirectory'
    parent: vNet
    properties: {
     addressPrefix:  activedirectorysubnetPrefix
     defaultOutboundAccess: defaultOutboundAccess
    }
  }

resource gtwysubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
    name: 'GatewaySubnet'
    parent: vNet
    properties: {
     addressPrefix: gtwyaddressPrefix
     defaultOutboundAccess: defaultOutboundAccess
    }
  }

@description('Public IP SKU "BASIC" will be retired Sep 30 2025')
param publicipsku object
@allowed([
  'IPv4'
  'IPv6'
])
param publicIPAddressVersion string
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string
resource publicip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
    name: '${publicipName}-${environment}'
    location: location
    tags: resourcetags
    sku: publicipsku
    properties: {
      publicIPAddressVersion: publicIPAddressVersion
      publicIPAllocationMethod: publicIPAllocationMethod
      idleTimeoutInMinutes: 4
      deleteOption: 'Delete'
    }
  }

param privateIPAddressVersion string
param privateipconfig string
param privateipaddress string
param privateIPAllocationMethod string
resource aducnetworkinterface 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: '${aducnetworkinterfaceName}-${environment}'
  location: location
  properties: {
    networkSecurityGroup: {
       id: aducNSG.id
    }
   ipConfigurations: [
     {
       name: privateipconfig
       properties: {
         privateIPAddressVersion: privateIPAddressVersion
         privateIPAllocationMethod: privateIPAllocationMethod
          privateIPAddress: privateipaddress
         subnet: {
          id: activedirectorysubnet.id
        }        
       }
     }
   ]
  
  }
}

@secure()
@description('Public IP of the On-Prem network device.')
param localgatewayIpAddress string
param localgatewayaddressPrefixes array
resource localnetworkgtwy 'Microsoft.Network/localNetworkGateways@2023-11-01' = {
  name: '${localnetworkgtwyName}-${environment}'
  location: location
  tags: resourcetags
  properties: {
    gatewayIpAddress: localgatewayIpAddress
    localNetworkAddressSpace: {
       addressPrefixes: localgatewayaddressPrefixes
    }
  }
}

@allowed([
  'ExpressRoute'
  'LocalGateway'
  'VPN'
])
param gatewayType string
@allowed([
  'Generation1'
  'Generation2'
])
param vpnGatewayGeneration string
param gatewaySku object
param activeActive bool
param gtwyaddressPrefix string
@allowed([
  'PolicyBased'
  'RouteBased'])
param vpntype string
param enablePrivateIpAddress bool
resource vpngtwy1 'Microsoft.Network/virtualNetworkGateways@2023-11-01' = {
  name: '${vpnGTWYName}-${environment}'
  location: location
  tags: resourcetags
  properties: {
    enablePrivateIpAddress: enablePrivateIpAddress
    vpnType: vpntype
    gatewayType: gatewayType
    sku: gatewaySku
    vpnGatewayGeneration: vpnGatewayGeneration
    activeActive: activeActive
    ipConfigurations: [
       {
         name: 'gtwypublicip'
          properties: {
             privateIPAllocationMethod: 'Dynamic'
             publicIPAddress: {
               id: publicip.id
             }
             subnet: {
                 id: gtwysubnet.id
              }
          }
       }
    ]
  }
}

@secure()
param authorizationKey string 
@allowed([
  'IPsec'
  'ExpressRoute'
  'Vnet2Vnet'
  'VPNClient'
])
@description('IPsec refers to Site-to-Site VPN')
param connectionType string
param connectionMode string
@allowed(['IKEv1','IKEv2'])
param connectionProtocol string
param ipsecPolicies array
param dpdTimeoutSeconds int
resource connection 'Microsoft.Network/connections@2023-11-01' = {
  name: connectionName
  location: location
  tags: resourcetags
  properties: {
    authorizationKey: authorizationKey
    connectionType: connectionType
    connectionMode: connectionMode
    connectionProtocol: connectionProtocol
    ipsecPolicies: ipsecPolicies
    dpdTimeoutSeconds: dpdTimeoutSeconds
      virtualNetworkGateway1: {
         id: vpngtwy1.id
         properties: {
         }
       }
       localNetworkGateway2: {
         id: localnetworkgtwy.id
         properties: {}
       }
}
  }

resource routetable 'Microsoft.Network/routeTables@2023-11-01' = {
  name: '${routetableName}-${environment}'
  location: location
}
