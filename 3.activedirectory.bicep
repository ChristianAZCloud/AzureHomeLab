// Global Parameters 
@secure()
param adminPWD string
param adminUSER string



// Module Parameters and Variables 
param location string = resourceGroup().location
param bootDiagnosticsenabled bool
param deleteoption string
param vmSize string
param imagereference object
param vmNamePrefix string
var vmName = '${vmNamePrefix}${location}'

resource NIC 'Microsoft.Network/networkInterfaces@2023-11-01' existing = {
  name: 'aduceastus'
}

resource ADUC 'Microsoft.Compute/virtualMachines@2023-09-01' = {
name:  vmName
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
             winRM: {
               listeners: [
                 {
                   protocol: 'Https'
                   
                 }
               ]
             }
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
   diskSizeGB: 64
    
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
