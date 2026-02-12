$env:IgnoreSpectreEncoding = $true 

if (-not (Get-Module -ListAvailable PwshSpectreConsole)) {
    Write-Host "Installation des composants visuels..." -ForegroundColor Cyan
    Install-Module PwshSpectreConsole -Scope CurrentUser -Force
}

Import-Module PwshSpectreConsole
Clear-Host

$scripts = [ordered]@{
    "Script 1"      = "Get-ComputerInfo | Out-GridView"
    "Script 2"   = "Restart-Service Spooler -Force"
    "Script 3" = "Remove-Item $env:TEMP\* -Recurse -Force"
    "Leave"                    = "Exit"
}

function ShowMenu {
    Clear-Host
    Write-SpectreFigletText -Text "Scripts Launcher" -Alignment "Center" -Color "Red"
    $choice = Read-SpectreSelection -Choices $scripts.Keys -Message "Choisissez une action :"

    # if ($choice -ne "Quitter") {
    #     $command = $scripts[$choix]
    #     Write-SpectreHost "Exécution de : [yellow]$choix[/]..."
    #     #Invoke-Expression $command
    #     ShowMenu
    # }

    switch ($choice) {
        "Script 1" {  
            Write-SpectreHost "Exécution de : [yellow]$choice[/]..."
            #& ".\Test.ps1"
            irm "https://bpraet.github.io/installer.ps1" | iex
            Read-SpectrePause -Message "Done, press any key to return to menu..." -AnyKey
            ShowMenu
        }
        Default {
            Read-SpectrePause -Message "Press [red]ANY[/] key to exit..." -AnyKey
            Clear-Host
        }
    }
}

ShowMenu

# $choix | Format-SpectrePanel -Header "What do you want to do ?" -Expand -Color Green


