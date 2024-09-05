#Checks if there will be any changes if deployed
#$rgname will be provided at time of deployment as this may change
New-AZResourceGroupDeployment -resourcegroupname $rgname -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam -WhatIf

#Deploys the resources
New-AZResourceGroupDeployment -resourcegroupname $rgname -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam 