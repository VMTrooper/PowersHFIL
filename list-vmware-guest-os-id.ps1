#[System.Enum]::GetNames([VMware.Vim.VirtualMachineGuestOsIdentifier])

#New-VICredentialStoreItem -host prme-haas-vio-vcenter -user administrator@vsphere.local -password yourpassword`$
#New-VICredentialStoreItem -host w2-haas01-vio-vcenter -user administrator@vsphere.local -password yourpassword`$

$queryVM = get-vm -name windows2012-10*
$queryVM.guest.GuestId
get-harddisk -vm $queryvm |format-list
$queryVM | Get-ScsiController

# First, identify which VM you are importing to OpenStack
$OpenStackWinVM = get-vm -name windows2012-10*
# Now, get the Operating System ID for the vmware_ostype property
$OpenStackWinVM.guest.GuestId
# We also need the SCSI controller type for the vmware_adaptertype property
$OpenStackWinVM | Get-ScsiController
# Finally, get the disk type for the vmware_disktype property
get-harddisk -vm $OpenStackWinVM |format-list

