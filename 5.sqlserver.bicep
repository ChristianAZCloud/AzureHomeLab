// Global Parameters 
param environment string
param location string = resourceGroup().location



// Module Parameters and Variables 
@secure()
param adminPWD string
param adminUSER string
param bootDiagnosticsenabled bool
param deleteoption string
param vmSize string
param imagereference object
param diskSizeGB int
var vmName = 'sv-sql'
var sqlsvrnetworkinterfaceName = 'sqlsvrNIC'


resource NIC 'Microsoft.Network/networkInterfaces@2023-11-01' existing = {
  name: '${sqlsvrnetworkinterfaceName}-${environment}'
}

resource ADUC 'Microsoft.Compute/virtualMachines@2023-09-01' = {
name:  '${vmName}-${environment}'
location: location 
properties: {
 diagnosticsProfile: {
   bootDiagnostics: {
     enabled: bootDiagnosticsenabled
   }
 }
   networkProfile: {
     networkInterfaces: [
       {
         id: NIC.id
         properties: {
           deleteOption: deleteoption
         }
       }
     ]
   }
    
    osProfile: {
       adminPassword: adminPWD
       adminUsername: adminUSER
       computerName: vmName
       windowsConfiguration: {
             timeZone: 'Eastern Standard Time'
          }
    }
hardwareProfile: {
   vmSize:  vmSize
}
storageProfile: {
   imageReference: imagereference
   osDisk: {
    createOption:  'FromImage' 
    deleteOption: 'Detach'
   diskSizeGB: diskSizeGB
    
   }
}
securityProfile: {
   securityType: 'TrustedLaunch'
  uefiSettings: {
     secureBootEnabled: true
     vTpmEnabled: true
  }
}
  
}

}
