#Checks if there will be any changes if deployed
#$rgname will be provided at time of deployment as this may change
New-AZResourceGroupDeployment -resourcegroupname $rgname -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam -Inc -WhatIf

#Deploys the resources
New-AZResourceGroupDeployment -resourcegroupname $rgname -TemplateFile .\0.main.bicep  -TemplateParameterFile .\0.parameters-prod.bicepparam 

#Gets Logging Information about a Deployment 
Get-AzResourceGroupDeploymentOperation -ResourceGroupName $rgname -DeploymentName vNet

az deployment group validate --resource-group $rgname --template-file .\0.main.bicep --template-p

Test-AzResourceGroupDeployment -ResourceGroupName $rgname -TemplateFile .\0.main.bicep -TemplateParameterFile .\0.parameters-prod.bicepparam