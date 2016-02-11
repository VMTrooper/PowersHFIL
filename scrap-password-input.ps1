$env:VpnPassword =  (Get-Credential).Password
$Password = Read-Host -Prompt "OpenStack User Password?" -AsSecureString
$env:OS_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))