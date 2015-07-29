#Credit to William Lam
#http://www.virtuallyghetto.com/2013/11/automate-reverse-migrating-from-vsphere.html#comment-32949
#http://lamw.github.io/
#https://github.com/lamw

Connect-VIServer -Server vcenter55-1.primp-industries.com -User administrator@vsphere.local -Pass vmware</b></i>

# ESXi hosts to migrate from VSS-&gt;VDS
$vmhost_array = @("vesxi55-1.primp-industries.com","vesxi55-2.primp-industries.com","vesxi55-3.primp-industries.com")

# VDS to migrate from
$vds_name = "VDS-01"
$vds = Get-VDSwitch -Name $vds_name

# VSS to migrate to
$vss_name = "vSwitch0"

# Name of portgroups to create on VSS
$mgmt_name = "Management Network"
$storage_name = "Storage Network"
$vmotion_name = "vMotion Network"

foreach ($vmhost in $vmhost_array) {
Write-Host "`nProcessing" $vmhost

# pNICs to migrate to VSS
Write-Host "Retrieving pNIC info for vmnic0,vmnic1,vmnic2,vmnic3"
$vmnic0 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic0"
$vmnic1 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic1"
$vmnic2 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic2"
$vmnic3 = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmnic3"

# Array of pNICs to migrate to VSS
Write-Host "Creating pNIC array"
$pnic_array = @($vmnic0,$vmnic1,$vmnic2,$vmnic3)

# vSwitch to migrate to
$vss = Get-VMHost -Name $vmhost | Get-VirtualSwitch -Name $vss_name

# Create destination portgroups
Write-Host "`Creating" $mgmt_name "portrgroup on" $vss_name
$mgmt_pg = New-VirtualPortGroup -VirtualSwitch $vss -Name $mgmt_name

Write-Host "`Creating" $storage_name "Network portrgroup on" $vss_name
$storage_pg = New-VirtualPortGroup -VirtualSwitch $vss -Name $storage_name

Write-Host "`Creating" $vmotion_name "portrgroup on" $vss_name
$vmotion_pg = New-VirtualPortGroup -VirtualSwitch $vss -Name $vmotion_name

# Array of portgroups to map VMkernel interfaces (order matters!)
Write-Host "Creating portgroup array"
$pg_array = @($mgmt_pg,$storage_pg,$vmotion_pg)

# VMkernel interfaces to migrate to VSS
Write-Host "`Retrieving VMkernel interface details for vmk0,vmk1,vmk2"
$mgmt_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk0"
$storage_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk1"
$vmotion_vmk = Get-VMHostNetworkAdapter -VMHost $vmhost -Name "vmk2"

# Array of VMkernel interfaces to migrate to VSS (order matters!)
Write-Host "Creating VMkernel interface array"
$vmk_array = @($mgmt_vmk,$storage_vmk,$vmotion_vmk)

# Perform the migration
Write-Host "Migrating from" $vds_name "to" $vss_name"`n"
Add-VirtualSwitchPhysicalNetworkAdapter -VirtualSwitch $vss -VMHostPhysicalNic $pnic_array -VMHostVirtualNic $vmk_array -VirtualNicPortgroup $pg_array  -Confirm:$false
}

Write-Host "`nRemoving" $vmhost_array "from" $vds_name
$vds | Remove-VDSwitchVMHost -VMHost $vmhost_array -Confirm:$false

<i><b>Disconnect-VIServer -Server $global:DefaultVIServers -Force -Confirm:$false
