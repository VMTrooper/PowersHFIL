# Global Variables
$vCenter = "****"
$vcuser = "*****"
$vcpass = "*****"
$WarningPreference = "SilentlyContinue"

# Login to vCenter
Write-Host "vC: Logging into vCenter: $vCenter"
$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null

# Logout of vCenter
Write-Host "vC: Logging out of vCenter: $vCenter"
$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false