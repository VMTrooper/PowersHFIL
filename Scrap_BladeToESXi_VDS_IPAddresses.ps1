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

#$vds = Get-Datacenter -Name "Vblock" | Get-VDSwitch
#Write-Host $vds


$vm = Get-VM vmname
#$vdswitch = Get-VDSwitch | where {$_.Name -eq "VSM03"}
$portgroup = Get-VDPortGroup -Name "10.10.10.x" -VDSwitch "VSM03"
#Get-VDPortgroup -VDSwitch "VSMVblock"
Get-NetworkAdapter -VM $vm | Set-NetworkAdapter -DistributedSwitch $vdswitch -Portgroup $portgroup

#PS C:\Users\Alan Renouf\Documents> Get-VDSwitch
# 
#Name                           NumPorts   Mtu        Version  Vendor
#----                           --------   ---        -------  ------
#Nexus1000V-VSM                 400                   4.0      Cisco Systems Inc.
#VDS-01                         60         1500       5.1.0    VMware
# 
# 
# 
#PS C:\Users\Alan Renouf\Documents> Get-VDSwitch Nexus*
#Get-VDSwitch : 2/14/2013 12:10:01 PM    Get-VDSwitch        Unable to cast object of type 'VMware.Vim.DistributedVirtua
#lSwitch' to type 'VMware.Vim.VmwareDistributedVirtualSwitch'.
#At line:1 char:13
#+ Get-VDSwitch <<<<  Nexus*
#    + CategoryInfo          : NotSpecified: (:) [Get-VDSwitch], VimException
#    + FullyQualifiedErrorId : Core_BaseCmdlet_UnknownError,VMware.VimAutomation.Vds.Commands.GetVDSwitch
# 
# 
#PS C:\Users\Alan Renouf\Documents> Get-VDSwitch | Select -first 1
# 
#Name                           NumPorts   Mtu        Version  Vendor
#----                           --------   ---        -------  ------
#Nexus1000V-VSM                 400                   4.0      Cisco Systems Inc.
# 
# 
# 
#PS C:\Users\Alan Renouf\Documents> Get-VDSwitch | Select -first 1 | Select *
# 
# 
#Name           : Nexus1000V-VSM
#ExtensionData  : VMware.Vim.DistributedVirtualSwitch
#NumPorts       : 400
#Key            : 19 d3 3b 50 2e 18 80 eb-fe 40 87 b7 5f c9 8b 7d
#Mtu            :
#Notes          : Cisco_Nexus_1000V_2030626814
#Datacenter     : Datacenter01
#NumUplinkPorts : 32
#ContactName    :
#ContactDetails :
#Version        : 4.0
#Vendor         : Cisco Systems Inc.
#Folder         : Nexus1000V-VSM
#MaxPorts       : 8192
#Id             : DistributedVirtualSwitch-dvs-169
#Uid            : /VIServer=root@10.20.181.182:443/DistributedSwitch=DistributedVirtualSwitch-dvs-169/
# 
#
#Get-VDSwitch | Where-Object {$_.Name -eq "VSM03"}

#	# Get List of Hosts and their Service Profiles (OEM Strings)
#	foreach ($esxi in Get-VMHost ) {
#		
#		# Get Information such as Hostname (As configured in VMware), Model, Version of ESX, Applied Host Profile and UUID
#		$VMHost_Name = $esxi.Name
#		$VMHost_Model = $esxi.ExtensionData.hardware.SystemInfo.Model
#		$VMHost_ESXVersion = $esxi.ExtensionData.Config.Product.FullName
#		$VMHost_HostProfile = ($VMHost | Get-VMHostProfile).name
#
#		# UUID is the attribute used to tie the VMware server object with UCS Service Profile
#		$VMHost_UUID = $esxi.ExtensionData.hardware.SystemInfo.Uuid
#
#		# Gets the UCS Service Profile object based on the UUID collected from vSphere above
#		$UCSServer = Get-UcsServiceProfile -Uuid $VMHost_UUID
#		# Get information on the Service Profile, such as the name of the UCS Manager, Service profile and Location within the UCS
#		$UCSServer_UCSName = $UCSServer.Ucs
#		$UCSServer_Pofile = $UCSServer.Name
#		$UCSServer_Location = $UCSServer.PnDn
#
#		# Writes the output in CSV format
#		Write-Host $VMHost_Name","$VMHost_Model","$VMHost_ESXVersion","$UCSServer_UCSName","$UCSServer_Pofile","$UCSServer_Location
#	}
#	#IP Information
#	$IPaddresses = @()
#
#foreach($vm in Get-VM){
#    $vm.Guest.Nics | %{
#        $row = "" | Select Name, IP, MAC
#        $row.Name = $vm.Name
#        $row.IP = &{if($_.IPAddress){[String]::Join(',',$_.IPAddress)}}
#        $row.MAC = $_.MacAddress
#        $IPaddresses += $row
#    }
#}
#
#Get-VMHost | Get-VMHostNetworkAdapter -VMKernel | %{
#    $row = "" | Select Name, IP, MAC
#    $row.Name = $_.VMHost.Name
#    $row.IP = $_.IP
#    $row.MAC = $_.MAC
#    $IPaddresses += $row
#}
#$IPaddresses
#$IPaddresses | Export-csv "C:\report.csv" -NoTypeInformation -UseCulture
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