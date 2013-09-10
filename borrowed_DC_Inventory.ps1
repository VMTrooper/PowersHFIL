###################
## DC_Inventory.ps1 by Joe Keegan
## Generates CSV output of VMHost and UCS Service profile information for the purposes of
## relating the virtual environment with the physical environment
##
## This script must be run from a PowerCLI session that is already connected to your
## VC Servers and UCS Managers
##
###################

# Generate a list of VMware Data Centers configured in your VCs
$DC_List = Get-Datacenter

# Generates the header line for the data
Write-Host "DataCenter,Cluster,VMHost Name,VMHost Model,ESXi Version,Host Profile,UCS System Name,UCS Service Profile,UCS Server Location"

# Iterates through each of the DCs.
foreach ($DC in $DC_List) {
$DC_Name = $DC.Name

# Gets a lists of clusters included in the DC and iterates through them
$Cluster_List = $DC | get-cluster
foreach ($Cluster in $Cluster_List) {
$Cluster_Name = $Cluster.Name

# Gets a list of Hosts in each clusters and iterates through them
$VMHost_List = $Cluster | get-vmhost
foreach ($VMHost in $VMHost_List) {

# Get Information such as Hostname (As configured in VMware), Model, Version of ESX, Applied Host Profile and UUID
$VMHost_Name = $VMHost.Name
$VMHost_Model = $VMHost.ExtensionData.hardware.SystemInfo.Model
$VMHost_ESXVersion = $VMHost.ExtensionData.Config.Product.FullName
$VMHost_HostProfile = ($VMHost | Get-VMHostProfile).name

# UUID is the attribute used to tie the VMware server object with UCS Service Profile
$VMHost_UUID = $VMHost.ExtensionData.hardware.SystemInfo.Uuid

# Gets the UCS Service Profile object based on the UUID collected from vSphere above
$UCSServer = Get-UcsServiceProfile -Uuid $VMHost_UUID
# Get information on the Service Profile, such as the name of the UCS Manager, Service profile and Location within the UCS
$UCSServer_UCSName = $UCSServer.Ucs
$UCSServer_Pofile = $UCSServer.Name
$UCSServer_Location = $UCSServer.PnDn

# Writes the output in CSV format
Write-Host $DC_Name","$Cluster_Name","$VMHost_Name","$VMHost_Model","$VMHost_ESXVersion","$VMHost_HostProfile","$UCSServer_UCSName","$UCSServer_Pofile","$UCSServer_Location
}
}
}
