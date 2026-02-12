$laptop = Read-Host "Target: "
$packageID = Read-Host "Winget package ID: "
#Push script to remote target
#Ex path winget: 'C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.26.430.0_x64__8wekyb3d8bbwe\winget.exe'
@"
`$winget = (gci -recurse -filter "winget.exe" -File -Path "C:\Program Files\WindowsApps\").FullName
& `$winget install $packageID -h --accept-package-agreements --accept-source-agreements --ignore-warnings --disable-interactivity --force > C:\temp\execNow.log
"@ > \\$laptop\c$\temp\execNow.ps1

#Execute script
Invoke-Command -ComputerName $laptop -ScriptBlock {
    $task = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-WindowStyle Hidden C:\temp\execNow.ps1"
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

    Register-ScheduledTask -TaskName "execNow" -User "System" -Action $task -Settings $settings
    Start-ScheduledTask -TaskName "execNow"

}
