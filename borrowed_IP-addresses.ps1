$IPaddresses = @()

foreach($vm in Get-VM){
    $vm.Guest.Nics | %{
        $row = "" | Select Name, IP, MAC
        $row.Name = $vm.Name
        $row.IP = &{if($_.IPAddress){[String]::Join(',',$_.IPAddress)}}
        $row.MAC = $_.MacAddress
        $IPaddresses += $row
    }
}

Get-VMHost | Get-VMHostNetworkAdapter -VMKernel | %{
    $row = "" | Select Name, IP, MAC
    $row.Name = $_.VMHost.Name
    $row.IP = $_.IP
    $row.MAC = $_.MAC
    $IPaddresses += $row
}

$IPaddresses | Export-csv "C:\report.csv" -NoTypeInformation -UseCulture