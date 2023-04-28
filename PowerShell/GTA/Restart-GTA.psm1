function Start-GTAReplayGlitch {
	
	# Check if we're running as admin
	if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Write-Warning "This script must be run as an administrator. Please run PowerShell as an administrator and try again."
		break
	}
	
	Write-Host -ForegroundColor Yellow "Do the heist as normal and escape into the water"
	Write-Host ""

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you in the water and ready to disable saving? (y/n)"
		Write-Host ""
		if ($Prompt -eq "y") {
			Write-Host -ForegroundColor DarkGreen "Creating firewall rule to block Rockstar server 192.81.241.171"
			New-NetFirewallRule -Name "Block GTA" -DisplayName "Block GTA" -Direction Outbound -Action Block -RemoteAddress "192.81.241.171"
			$InputReceived = $true
		}
		elseif ($Prompt -eq "n") {
			Write-Host "Exiting"
			Remove-NetFirewallRule -Name "Block GTA"
			throw "Exiting"
			$InputReceived = $true
		}
		else {
			Write-Host -ForegroundColor Red "Invalid input, please enter 'y' or 'n'"
		}
	}
		
	Write-Host -ForegroundColor Yellow "Wait until your character hands over the bag and the message 'SAVING FAILED' has popped up in the bottom left"
	Write-Host ""

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you ready to restart GTA? (y/n)"
		Write-Host ""
		if ($Prompt -eq "y") {
			Write-Host -ForegroundColor DarkGreen "Restarting GTA and removing firewall rule"
			Write-Host ""
			Get-Process "GTA*","Rockstar*","SocialClub*","Launcher*" | Stop-Process -Force
			Remove-NetFirewallRule -Name "Block GTA"

			$Seconds = 10
			Write-Host "Sleeping for $Seconds seconds"
			Write-Host ""

			1..$Seconds | ForEach-Object {
				$Percent = $_ * 100 / $Seconds
				Write-Progress -Activity "Sleeping for $Seconds seconds" -Status "$($Seconds - $_) seconds remaining" -PercentComplete $Percent 
				Start-Sleep -Seconds 1
				}
			
			Write-Host -ForegroundColor DarkGreen "GTA has been killed and the firewall rule has been removed"
			Write-Host ""
			Write-Host -ForegroundColor DarkGreen "Starting GTA"
			Write-Host ""
			Start-Process "C:\Users\Conor\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Grand Theft Auto V.url"

			$InputReceived = $true
		}
		elseif ($Prompt -eq "n") {
			Write-Host "Exiting"
			Remove-NetFirewallRule -Name "Block GTA"
			throw "Exiting"
			$InputReceived = $true
		}
		else {
			Write-Host -ForegroundColor Red "Invalid input, please enter 'y' or 'n'"
		}
	}
}