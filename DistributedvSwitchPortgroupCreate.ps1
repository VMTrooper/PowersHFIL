# Import Modules

#if ((Get-PSSnapin | where {$_.Name -ilike "Vmware*Core"}).Name -ine "VMware.VimAutomation.Core")
#	{
#	Write-Host "Loading PS Snap-in: VMware VimAutomation Core"
#	Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
#	}

# Global Variables
$vCenter = "prme-haas-2-vio-vcenter"
$vcuser = "administrator@vsphere.local"
$vcpass = "VMware1!"
$WarningPreference = "SilentlyContinue"

# Login to vCenter
Write-Host "vC: Logging into vCenter: $vCenter"
$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null

# Source: https://dthomo.wordpress.com/2013/07/19/create-a-csv-of-port-group-names-and-vlan-ids-for-both-standard-and-distributed-vswitches/
foreach ($pg in get-vdportgroup | where {$_.Name -ilike "Management*"} | Where { $_.Name -NotMatch “-Uplinks” }) {
$pg.Name
$pg.ExtensionData.Config.DefaultPortConfig.Vlan.VlanId
}

#Management External API
#964
#Management Floating IP
#974
#Management vMotion
#3101
#Management NFS
#3100

$myvds = Get-VDSwitch | Where-Object {$_.Name -ilike "*Edge*"}

New-VDPortgroup -VDSwitch $myvds -Name "Management External API" -VlanId 964
New-VDPortgroup -VDSwitch $myvds -Name "Management Floating IP" -VlanId 974
New-VDPortgroup -VDSwitch $myvds -Name "Management vMotion" -VlanId 3101
New-VDPortgroup -VDSwitch $myvds -Name "Management NFS" -VlanId 3100

# Logout of vCenter
Write-Host "vC: Logging out of vCenter: $vCenter"
$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false