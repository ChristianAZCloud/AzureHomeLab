#Checks if there will be any changes if deployed
New-AZResourceGroupDeployment -resourcegroupname 'eastUS-KeyVault-rg' -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam -WhatIf

#Deploys the resources
New-AZResourceGroupDeployment -resourcegroupname 'eastUS-KeyVault-rg' -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam 