$env:IgnoreSpectreEncoding = $true 

if (-not (Get-Module -ListAvailable PwshSpectreConsole)) {
    Write-Host "Please wait..." -ForegroundColor Cyan
    Install-Module PwshSpectreConsole -Scope CurrentUser -Force
}

Import-Module PwshSpectreConsole
Clear-Host

$scripts = [ordered]@{
    "Test script" = "test"
    "Install app from Winget as System" = "runAsSystemWingetInstall"
    "Script 3" = ""
    "Leave" = "Leave"
}

function ShowMenu {
    Clear-Host
    Write-SpectreFigletText -Text "Scripts Launcher" -Alignment "Center" -Color "Red"
    $choice = Read-SpectreSelection -Choices $scripts.keys -Message "Select a script:"

    if($choice -eq "Leave") {
        Read-SpectrePause -Message "Press [red]ANY[/] key to exit..." -AnyKey
        Clear-Host
    } else {
        Write-SpectreHost "[yellow]$choice[/] running..."
        irm "https://bpraet.github.io/$($scripts[$choice]).ps1" | iex
        Read-SpectrePause -Message "Done, press any key to return to menu..." -AnyKey
        ShowMenu
    
    }
}

ShowMenu
