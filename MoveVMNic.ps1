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

$VMtest = Get-VM -Name "Win2k3-02"
Write-Host "Test"
$testNIC = Get-NetworkAdapter -VM $VMtest 
Get-VirtualSwitch -VM $VMtest
Get-VirtualPortGroup -VM $VMtest
Get-VMGuestNetworkInterface -VM $VMtest
Get-VM
Write-Host $testNIC

$server = get-vmhost -name "san-cc2-blade24.san-dc1-core.cscehub.com"
$vS0 = Get-VirtualSwitch -VMHost $server -Standard -Name vSwitch0
Get-VMHostNetworkAdapter -VMHost $server -
Remove-VMHostNetworkAdapter

	# Logout of vCenter
	Write-Host "vC: Logging out of vCenter: $vCenter"
	$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false

