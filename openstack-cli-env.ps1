$env:OS_AUTH_URL="https://prme-haas-2-vio-dashboard.eng.vmware.com:5000/v2.0"
$env:OS_TENANT_NAME="demo-project"
$env:OS_USERNAME="demo-user"
$env:OS_CACERT="\\vmware-host\Shared Folders\Downloads\vio.pem"
$Password = Read-Host -Prompt "OpenStack User Password?" -AsSecureString
$env:OS_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))