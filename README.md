# AzureHomeLab
# In this Lab I have a pfsense firewall and windows server 2022 domain contoller on Hyper-V. I also have a VPN Gateway setup to connect my Hyper-V domain contoller to my domain controller running in Azure. 

# Added a routetable to route traffic from my ActiveDirectory Subnet to the VPNGTWY which addressed an issue with being unable to ping my local network from Azure VM

# 9/14/24 Update
# Deployed two additional servers for an SCCM Lab re-using the activedirectory.bicep module. Added new subnet and NICs for the new servers. 