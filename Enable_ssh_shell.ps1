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
  Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM"} )
}

#Get-VMHost | Foreach {
#  Stop-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )
#  Stop-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM"} )
#}

#Verify if service is running

#Get-VMHost | Get-VMHostService | Where { $_.Key - -eq "TSM-SSH" } |select VMHost, Label, Running
#Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM" } |select VMHost, Label, Running
#Get-VMHost | Get-VMHostService | Where { $_.Key -match "TSM" } | Where ($_.Running = "True") | select VMHost, Label, Running

#Optimized NOTE: {} used instead of () for Boolean Check because of the cast error included below 
Get-VMHost | Get-VMHostService | Where { $_.Key -match "TSM" } | Where {$_.Running -eq "True"} | select VMHost, Label, Running

#ERROR: Where-Object : Cannot bind parameter 'FilterScript'. Cannot convert value "False" to type "System.Management.Automation.ScriptBlock". Error: "Invalid cast from 'System.Boolean' to 'System.Management.Automation.ScriptBlock'."
#EXPLANATION: the parameter requires Script Block to be passed, Which is in curly braces. Just  replace your round braces with curly.

#######################Action Code Ends###########################################
# Logout of vCenter
Write-Host "vC: Logging out of vCenter: $vCenter"
$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false

