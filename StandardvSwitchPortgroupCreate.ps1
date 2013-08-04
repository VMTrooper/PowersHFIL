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
$vCenter = "XXXXXXXXXXXXX"
$vcuser = "Administrator"
$vcpass = "XXXXXXXXXXX"
$WarningPreference = "SilentlyContinue"

# Login to vCenter
Write-Host "vC: Logging into vCenter: $vCenter"
$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null

get-virtualportgroup -VirtualSwitch $swA02

#Done
$a01 = get-vmhost -name "emcwma01.corpeng03.rtp.vce.com"
$swA01 = get-virtualswitch -vmhost $a01
#Done
$a02 = get-vmhost -name "emcwma02.corpeng03.rtp.vce.com"
$swA02 = get-virtualswitch -vmhost $a02
#Done
$b01 = get-vmhost -name "emcwmb01.corpeng03.rtp.vce.com"
$swB01 = get-virtualswitch -vmhost $b01

$b02 = get-vmhost -name "emcwmb02.corpeng03.rtp.vce.com"
$swB02 = get-virtualswitch -vmhost $b02

$swB02 = get-virtualswitch -vmhost (get-vmhost -name "emcwmb02.corpeng03.rtp.vce.com") -Standard
New-VirtualPortGroup -VirtualSwitch $swB02 -Name ExternalDMZ -VLanId 300
New-VirtualPortGroup -VirtualSwitch $swB02 -Name InternalDMZ -VLanId 301
New-VirtualPortGroup -VirtualSwitch $swB02 -Name Demo_Desktops -VLanId 308
New-VirtualPortGroup -VirtualSwitch $swB02 -Name Desktops -VLanId 307
New-VirtualPortGroup -VirtualSwitch $swB02 -Name "EMCW N1kV Packet" -VLanId 161
New-VirtualPortGroup -VirtualSwitch $swB02 -Name "EMCW N1kV Control" -VLanId 162
New-VirtualPortGroup -VirtualSwitch $swB02 -Name vCOP -VLanId 311
New-VirtualPortGroup -VirtualSwitch $swB02 -Name "EMCW Management" -VLanId 309

	
	
	# Logout of vCenter
	Write-Host "vC: Logging out of vCenter: $vCenter"
	$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false

Get-EsxImageProfile -

add-esxsof