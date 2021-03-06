##################################################
# Joe Martin
# Cisco Systems, Inc.
# UCS Convert to UCS Cmdlet v1.4
# 11/22/13
# Code provided as-is.  No warranty implied or included.
# This code is for example use only and not for production
#
# To use this app do the following:
#	1 - Log into UCSM GUI
#	2 - Run this Script which will monitor the UCSM data stream
#	3 - Create or Delete something in UCSM GUI
#	4 - Look and capture the output in PowerShell of your UCS transaction
#	5 - When done, stop the script and then disconnect from UCSM
##################################################

#Setup PowerShell console colors for compatibility with my script colors
$PowerShellWindow = (Get-Host).UI.RawUI
$PowerShellWindow.BackgroundColor = "White"
$PowerShellWindow.ForegroundColor = "Black"

#Clear the screen
clear-host

#Script kicking off
Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Script Running..."
Write-Host ""

#Tell the user what the script does
Write-Host -ForegroundColor DarkBlue "This script will launch UCSM GUI and execute the ConvertTo-UcsCmdlet"
Write-Host ""
Write-Host -ForegroundColor DarkBlue "The value of this function is to learn the PowerShell required to perform"
Write-Host -ForegroundColor DarkBlue "a task"
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Just do something in UCSM, select SAVE and look at your PowerShell console"
Write-Host -ForegroundColor DarkBlue "to see the PowerShell commands"

#Do not show errors in script
$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Stop"
#$ErrorActionPreference = "Continue"
#$ErrorActionPreference = "Inquire"

#Verify PowerShell Version for script support
$PSVersion = $psversiontable.psversion
$PSMinimum = $PSVersion.Major
if ($PSMinimum -ge "3")
	{
	}
else
	{
		Write-Host -ForegroundColor Red "This script requires PowerShell version 3 or above"
		Write-Host -ForegroundColor Red "Please update your system and try again."
		Write-Host -ForegroundColor Red "You can download PowerShell updates here:"
		Write-Host -ForegroundColor Red "	http://search.microsoft.com/en-us/DownloadResults.aspx?rf=sp&q=powershell+4.0+download"
		Write-Host -ForegroundColor Red "If you are running a version of Windows before 7 or Server 2008R2 you need to update to be supported"
		Write-Host -ForegroundColor Red "		Exiting..."
		Disconnect-Ucs
		exit
	}

#Load the UCS PowerTool
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Checking Cisco PowerTool"
$PowerToolLoaded = $null
$Modules = Get-Module
$PowerToolLoaded = $modules.name
if ( -not ($Modules -like "ciscoUcsPs"))
	{
		Write-Host -ForegroundColor DarkBlue "	Loading Module: Cisco UCS PowerTool Module"
		Import-Module ciscoUcsPs
		$Modules = Get-Module
		if ( -not ($Modules -like "ciscoUcsPs"))
			{
				Write-Host ""
				Write-Host -ForegroundColor Red "	Cisco UCS PowerTool Module did not load.  Please correct his issue and try again"
				Write-Host -ForegroundColor Red "		Exiting..."
				exit
			}
		else
			{
				Write-Host -ForegroundColor DarkGreen "	PowerTool is Loaded"
			}
	}
else
	{
		Write-Host -ForegroundColor DarkGreen "	PowerTool is Loaded"
	}

#Define UCS Domain(s)
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Validating Connectivity to UCSM"
Write-Host -ForegroundColor Magenta "	Enter UCS system IP or Hostname"
$myucs = Read-Host "Enter UCS system IP or Hostname"
if (($myucs -eq "") -or ($myucs -eq $null) -or ($Error[0] -match "PromptingException"))
	{
		Write-Host ""
		Write-Host -ForegroundColor Red "You have provided invalid input."
		Write-Host -ForegroundColor Red "	Exiting..."
		Disconnect-Ucs
		exit
	}
else
	{
		Disconnect-Ucs
	}

#Test that UCSM is IP Reachable via Ping
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Testing reachability to UCSM"
$ping = new-object system.net.networkinformation.ping
$results = $ping.send($myucs)
if ($results.Status -ne "Success")
	{
		Write-host -ForegroundColor Red "	Can not access UCSM $myucs by Ping"
		Write-Host ""
		Write-Host "It is possible that a firewall is blocking ICMP (PING) Access.  Would you like to try to log in anyway?"
		$Try = Read-Host "Would you like to try to log in anyway? (Y/N)"
		if ($Try -ieq "y")
			{
				Write-Host ""
				Write-Host -ForegroundColor DarkCyan "Trying to log in anyway!"
				Write-Host ""
			}
		elseif ($Try -ieq "n")
			{
				Write-Host ""
				Write-Host -ForegroundColor DarkBlue "You have chosen to exit"
				Write-Host -ForegroundColor White -BackgroundColor DarkBlue "	Exiting..."
				Disconnect-Ucs
				exit
			}
		else
			{
				Write-Host ""
				Write-Host -ForegroundColor Red "You have provided invalid input.  Please enter (Y/N) only."
				Write-Host -ForegroundColor Red "	Exiting..."
				Disconnect-Ucs
				exit
			}			
	}
else
	{
		Write-Host -ForegroundColor DarkGreen "	Successfully pinged UCSM:" -NoNewline
		Write-Host -ForegroundColor White -BackgroundColor DarkGreen $myucs
	}
	
#Allow Logins to single or multiple UCSM systems
$multilogin = Set-UcsPowerToolConfiguration -SupportMultipleDefaultUcs $false

#Log into UCSM
Write-Host ""
Write-Host  -ForegroundColor DarkBlue "Logging into UCSM"
Write-Host -ForegroundColor Magenta "	Provide UCSM login credentials"

#Verify PowerShell Version to pick prompt type
$PSVersion = $psversiontable.psversion
$PSMinimum = $PSVersion.Major
if ($PSMinimum -ge "3")
	{
		$cred = Get-Credential -Message "UCSM(s) Login Credentials" -UserName "admin"
	}
else
	{
		$cred = Get-Credential
	}
$myCon = Connect-Ucs $myucs -Credential $cred
if (($myucs | Measure-Object).count -ne ($myCon | Measure-Object).count) 
	{
	#Exit Script
	Write-Host -ForegroundColor Red "		Error Logging into UCS.  Make sure your user has login rights the UCS system and has the proper role/privledges to use this tool..."
	Write-Host -ForegroundColor Red "			Exiting..."
	Disconnect-Ucs
	exit
	}
else
	{
	Write-Host -ForegroundColor DarkGreen "		Login Successful"
	}
$myCon = Start-ucsguisession -logallxml

##Launch UCSM GUI
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Launching UCSM GUI"

#Wait till Java Log file is ready
function Start-Countdown
	{
		Param
			(
				[INT]$Seconds = (Read-Host "Enter seconds to countdown from")
			)
		while
			(
				$seconds -ge 0
			)
			{
    				Write-Progress -Activity "Sleep Timer Countdown" -SecondsRemaining $Seconds -Status "Time Remaining"
    				Start-Sleep -Seconds 1
				$Seconds --
			}
		Write-Progress -Completed -Activity "Sleep Timer Countdown"
	}
Write-Host ""
Write-Host -ForegroundColor DarkBlue "Waiting for 1 minute to make sure the UCSM log file is ready for use."
Write-Host -ForegroundColor Magenta "	The UCSM GUI is waiting for you to log in.  Please do so now."
Start-Countdown -seconds 60

##Execute the ConvertTo-UcsCmdlet option
Write-Host ""
Write-Host -ForegroundColor DarkBlue 'Executing ConvertTo-UcsCmdlet'
Write-Host -ForegroundColor DarkBlue "	Make sure to end script when done as this cmdlet will run forever still stopped"
Write-Host ""
ConvertTo-UcsCmdlet