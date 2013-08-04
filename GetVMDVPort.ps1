	# Global Variables
	$vCenter = "XXXXXXXXXXXXX"
	$vcuser = "Administrator"
	$vcpass = "XXXXXXXXXXXXX"
	$WarningPreference = "SilentlyContinue"
	
	# Login to vCenter
	Write-Host "vC: Logging into vCenter: $vCenter"
	$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null
	
	$VMtest = Get-VM -Name "Win2k3-02"
	Write-Host "Test"
	$testNIC = Get-NetworkAdapter -VM $VMtest 
	Get-VirtualSwitch -VM $VMtest
	Get-VirtualPortGroup -VM $VMtest
	Get-VMGuestNetworkInterface -VM $VMtest
	Get-VM
	Write-Host $testNIC