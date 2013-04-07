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
<#
if ((Get-PSSnapin | where {$_.Name -ilike " VMware.DeployAutomation"}).Name -ine "VMware.DeployAutomation")
	{
	Write-Host "Loading PS Snap-in: VMware VMware.DeployAutomation"
	Add-PSSnapin VMware.DeployAutomation -ErrorAction SilentlyContinue
	}
if ((Get-PSSnapin | where {$_.Name -ilike "VMware.ImageBuilder"}).Name -ine "VMware.ImageBuilder")
	{
	Write-Host "Loading PS Snap-in: VMware VMware.ImageBuilder"
	Add-PSSnapin VMware.ImageBuilder -ErrorAction SilentlyContinue
	}
#>

set-ucspowertoolconfiguration -supportmultipledefaultucs $false

# Global Variables
$ucs = "*"
$ucsuser = "*"
$ucspass = "*"
$ucsorg = "org-root"
$vCenter = "*"
$vcuser = "*"
$vcpass = "*"
$WarningPreference = "SilentlyContinue"

Try {

	# Login to UCS
	Write-Host "UCS: Logging into UCS Domain: $ucs"
	$ucspasswd = ConvertTo-SecureString $ucspass -AsPlainText -Force
	$ucscreds = New-Object System.Management.Automation.PSCredential ($ucsuser, $ucspasswd)
	$ucslogin = Connect-Ucs -Credential $ucscreds $ucs

	# Login to vCenter
	Write-Host "vC: Logging into vCenter: $vCenter"
	$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null


	# Get List of Hosts and their Service Profiles (OEM Strings)
	foreach ($esxi in Get-VMHost ) {
		
		# Get Information such as Hostname (As configured in VMware), Model, Version of ESX, Applied Host Profile and UUID
		$VMHost_Name = $esxi.Name
		$VMHost_Model = $esxi.ExtensionData.hardware.SystemInfo.Model
		$VMHost_ESXVersion = $esxi.ExtensionData.Config.Product.FullName
		$VMHost_HostProfile = ($VMHost | Get-VMHostProfile).name

		# UUID is the attribute used to tie the VMware server object with UCS Service Profile
		$VMHost_UUID = $esxi.ExtensionData.hardware.SystemInfo.Uuid

		# Gets the UCS Service Profile object based on the UUID collected from vSphere above
		$UCSServer = Get-UcsServiceProfile -Uuid $VMHost_UUID
		# Get information on the Service Profile, such as the name of the UCS Manager, Service profile and Location within the UCS
		$UCSServer_UCSName = $UCSServer.Ucs
		$UCSServer_Pofile = $UCSServer.Name
		$UCSServer_Location = $UCSServer.PnDn

		# Writes the output in CSV format
		Write-Host $VMHost_Name","$VMHost_Model","$VMHost_ESXVersion","$UCSServer_UCSName","$UCSServer_Pofile","$UCSServer_Location
	}
	# Logout of UCS
	Write-Host "UCS: Logging out of UCS: $ucs"
	$ucslogout = Disconnect-Ucs 

	# Logout of vCenter
	Write-Host "vC: Logging out of vCenter: $vCenter"
	$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false
}
Catch
{
	 Write-Host "Error occurred in script:"
	 Write-Host ${Error}
     exit
}