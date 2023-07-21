#powershell.exe -noprofile -ExecutionPolicy Unrestricted -File PSUpdates.ps1

$UpdateSvc = New-Object -ComObject Microsoft.Update.ServiceManager
$UpdateSvc.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

Function WinUpdates {

Write-Output('Checking for driver updates...')
Write-Output('')

#(New-Object -ComObject Microsoft.Update.ServiceManager).Services

$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()

$Searcher.ServiceID = '7971f918-a847-4430-9279-4a52d1efe18d'
$Searcher.SearchScope =  1 # MachineOnly
$Searcher.ServerSelection = 3 # Third Party
          
$Criteria = "IsInstalled=0 and Type='Driver'"
$SearchResult = $Searcher.Search($Criteria)
$Updates = $SearchResult.Updates
	
#Show available Drivers...
#$Updates | select Title, DriverModel, DriverVerDate, Driverclass, DriverManufacturer | fl
#Write-Output($Updates | select Title, DriverModel | fl)

$UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
$updates | % { $UpdatesToDownload.Add($_) | out-null }
Write-Output('Downloading Drivers...')
Write-Output('')

$UpdateSession = New-Object -Com Microsoft.Update.Session
$Downloader = $UpdateSession.CreateUpdateDownloader()
$Downloader.Updates = $UpdatesToDownload
$Downloader.Download()

$UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
$updates | % { if($_.IsDownloaded) { $UpdatesToInstall.Add($_) | out-null } }

Write-Output('Installing Drivers...')
Write-Output('')

$Installer = $UpdateSession.CreateUpdateInstaller()
$Installer.Updates = $UpdatesToInstall
$InstallationResult = $Installer.Install()
if($InstallationResult.RebootRequired) { 
Write-Host('Reboot required! please reboot now..') -Fore Red
} else { Write-Host('Done..') -Fore Green }

}

WinUpdates;

Start-Sleep -Seconds 10

$updateSvc.Services | ? { $_.IsDefaultAUService -eq $false -and $_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d" } | % { $UpdateSvc.RemoveService($_.ServiceID) }
