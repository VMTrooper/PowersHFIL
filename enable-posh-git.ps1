﻿$env:TERM="msys"
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from default directory
Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

     $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet