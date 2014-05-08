1. Disable Firewall or create RPC Port Remotely
<Need code for this>

2. Update IP settings
<DNS works, but may have gremlins.  IP Settings need to be updated>
DNS First
<computerlist, dnsservers and netconnectionID need to change for each environment>

$Computerlist = get-content "C:\list.txt"
$dnsservers =@("192.168.10.3")

foreach ($computername in $computerlist) {
    $result =  get-wmiobject win32_pingstatus -filter "address='$computername'"
    if ($result.statuscode -eq 0) {
        $remoteNic = get-wmiobject -class win32_networkadapter -computer $computername | where-object {$_.netconnectionID -eq "Ethernet"}
        $index = $remotenic.index
        $DNSlist = $(get-wmiobject win32_networkadapterconfiguration -computer $computername -Filter ‘IPEnabled=true’ | where-object {$_.index -eq $index}).dnsserversearchorder
        $priDNS = $DNSlist | select-object -first 1
        Write-host "Changing DNS IP's on $computername" -b "Yellow" -foregroundcolor "black"
        $change = get-wmiobject win32_networkadapterconfiguration -computer $computername | where-object {$_.index -eq $index}
        $change.SetDNSServerSearchOrder($DNSservers) | out-null
        $changes = $(get-wmiobject win32_networkadapterconfiguration -computer $computername -Filter ‘IPEnabled=true’ | where-object {$_.index -eq $index}).dnsserversearchorder
        Write-host "$computername's Nic1 Dns IPs $changes"
    }
    else {
        Write-host "$Computername is down cannot change IP address" -b "Red" -foregroundcolor "white"
    }
}

IP Address Second

$InterfaceName = $Get-WmiObject Win32_NetworkAdapter | ?{$_.Description -eq $wmi.Description} | select -ExpandProperty NetConnectionID
Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {netsh interface ip set address $InterfaceName static $IPAddress $SubnetMask $DefaultGateway 1}


3. Join Domain:
add-computer -ComputerName portal-01 -domainname spsandbox1 -credential spsandbox1\administrator -localcredential administrator -restart
