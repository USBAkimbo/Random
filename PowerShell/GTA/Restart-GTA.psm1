function Restart-GTA {
	
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
			Get-NetAdapter Ethernet | Enable-NetAdapter -Confirm:$false
			throw "Exiting"
			$InputReceived = $true
		}
		else {
			Write-Host -ForegroundColor Red "Invalid input, please enter 'y' or 'n'"
		}
	}
		
	Write-Host ""
	Write-Host -ForegroundColor Yellow "Wait until your character hands over the bag and the message 'SAVING FAILED' has popped up in the bottom left"
	Write-Host ""

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you ready to disconnect your network adapter? (y/n)"
		Write-Host ""
		if ($Prompt -eq "y") {
			Write-Host -ForegroundColor DarkGreen "Disabling NIC"
			Get-NetAdapter Ethernet | Disable-NetAdapter -Confirm:$false
			$InputReceived = $true
		}
		elseif ($Prompt -eq "n") {
			Write-Host "Exiting"
			Remove-NetFirewallRule -Name "Block GTA"
			Get-NetAdapter Ethernet | Enable-NetAdapter -Confirm:$false
			throw "Exiting"
			$InputReceived = $true
		}
		else {
			Write-Host -ForegroundColor Red "Invalid input, please enter 'y' or 'n'"
		}
	}

	Write-Host ""
	Write-Host -ForegroundColor Yellow "Wait until you get a disconnection message and you get kicked back into single player"
	Write-Host ""
	Write-Host -ForegroundColor Yellow "If this doesn't happen, wait for the cutscene to end then pause and go into the Creator"
	Write-Host ""
	Write-Host -ForegroundColor Yellow "This will fail and will kick you back to single player"
	Write-Host ""

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you back in single player? (y/n)"
		Write-Host ""
		if ($Prompt -eq "y") {
			Write-Host -ForegroundColor DarkGreen "Enabling NIC and removing firewall rule"
			Write-Host ""
			Remove-NetFirewallRule -Name "Block GTA"
			Get-NetAdapter Ethernet | Enable-NetAdapter -Confirm:$false
			$InputReceived = $true
		}
		elseif ($Prompt -eq "n") {
			Write-Host "Exiting"
			Remove-NetFirewallRule -Name "Block GTA"
			Get-NetAdapter Ethernet | Enable-NetAdapter -Confirm:$false
			throw "Exiting"
			$InputReceived = $true
		}
		else {
			Write-Host -ForegroundColor Red "Invalid input, please enter 'y' or 'n'"
		}
	}

	Write-Host -ForegroundColor Yellow "All done!"
	Write-Host ""
	Write-Host -ForegroundColor Yellow "Now go back into online and the heist should be ready to go again"
	Write-Host ""

}


###

# Old script

#	Write-Host "Killing GTA"
#	Get-Process "*GTA*","Rockstar*","SocialClub*","Launcher*" | Stop-Process -Force
#	
#	$Seconds = 10
#	Write-Host "Sleeping for $Seconds seconds"
#	
#	1..$Seconds | ForEach-Object {
#	$Percent = $_ * 100 / $Seconds
#	Write-Progress -Activity "Sleeping for $Seconds seconds" -Status "$($Seconds - $_) seconds remaining" -PercentComplete $Percent 
#	Start-Sleep -Seconds 1
#	}
#	
#	Write-Host "Starting GTA"
#	Start-Process "C:\Users\Conor\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Grand Theft Auto V.url"
#	
#}