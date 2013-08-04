Connect-Ucs 172.16.67.30 -Credential (Get-Credential)
 
$csv = Import-Csv C:\PSInput\vlanlist.csv
 
foreach ($row in $csv)
{
write-host "Adding VLAN $($row.vlanid) with name $($row.name)"
Add-Ucsvlan -Id $row.vlanid -Name $row.name -Sharing none -LanCloud (Get-UcsLanCloud)
}
 
Disconnect-Ucs