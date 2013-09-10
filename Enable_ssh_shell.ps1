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

# Global Variables
$vCenter = "20.13.25.30"
$vcuser = "soe-load"
$vcpass = "V1rtu@1c3!"
$WarningPreference = "SilentlyContinue"

# Login to vCenter
Write-Host "vC: Logging into vCenter: $vCenter"
$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null
#######################Action Code Begins###########################################
Get-VMHost | Foreach {
  Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )
}
#######################Action Code Ends###########################################
# Logout of vCenter
Write-Host "vC: Logging out of vCenter: $vCenter"
$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false

