#Installation via winget système

$laptop = Read-SpectreText -Message "Target: "
$packageID = Read-SpectreText -Message "Winget package ID: "

#Check online
if (Test-Connection $laptop -Count 1 -ea SilentlyContinue -wa SilentlyContinue) {
    Write-Host "`n$laptop is online" -ForegroundColor Green
}
else {
    Write-Host "`n$laptop is not online" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to quit" | Out-Null
    exit
}

#Clean
if (Test-Path \\$laptop\c$\temp\execNow.ps1) {
    Remove-Item \\$laptop\c$\temp\execNow.ps1
}
else {
    Write-Host "No script"
}

Invoke-Command -ComputerName $laptop -ScriptBlock {
    Get-ScheduledTask -TaskName "execNow" -ErrorAction SilentlyContinue -OutVariable execNowTask

    if ($execNowTask) {
        Unregister-ScheduledTask -TaskName "execNow" -Confirm:$false
    }
    else {
        Write-Host "No task"
    }
}

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

Write-Host "Installation is running, logs are in C:\temp\execNow.log on target computer" -NoNewLine
$Host.UI.ReadLine()
exit
