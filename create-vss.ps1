#Create vSS on multiple servers automatically

$vmhost_array = @("server01.vmtrooper.com","server02.vmtrooper.com","server03.vmtrooper.com")
foreach ($vmhost in $vmhost_array) {
   New-VirtualSwitch -VMHost $vmhost -Name vSwitch1
}
