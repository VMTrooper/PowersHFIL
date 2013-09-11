# Import Modules
if ((Get-Module |where {$_.Name -ilike "CiscoUcsPS"}).Name -ine "CiscoUcsPS")
	{
	Write-Host "Loading Module: Cisco UCS PowerTool Module"
	Import-Module CiscoUcsPs
	}

if ((Get-PSSnapin | where {$_.Name -ilike "Vmware*Core"}).Name -ine "VMware.VimAutomation.Core")
	{
	Write-Host "Loading PS Snap-in: VMware VimAutomation Core"
	Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
	}



#######################Action Code Begins############################################
Get-vmhost | Get-VMHostNetworkAdapter -VMKernel | select VMHost, Name, DeviceName, IP | Export-Csv test.csv
#######################Action Code Ends##############################################

