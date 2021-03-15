# Define update criteria
$Criteria = "IsInstalled=0"

# Search for updates
Write-Host "Checking for updates"
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search($Criteria).Updates
Write-Host " "

# Download updates
Write-Host "Downloading updates"
$Session = New-Object -ComObject Microsoft.Update.Session
$Downloader = $Session.CreateUpdateDownloader()
$Downloader.Updates = $SearchResult
$Downloader.Download()
Write-Host " "

# Install updates
Write-Host "Installing updates"
$Installer = New-Object -ComObject Microsoft.Update.Installer
$Installer.Updates = $SearchResult
$Result = $Installer.Install()
Write-Host " "

# Reboot if required
if ($Result.rebootRequired) {Restart-Computer -Force} else {Write-Host "No reboot required"}