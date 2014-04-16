
#PS1
$user = [ADSI]("WinNT://./Administrator,user")
$user.SetPassword("`$uperman")
$user.SetInfo()
Rename-Computer -newname test -restart