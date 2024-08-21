function Start-GTAReplayGlitch {
	
	# Check if we're running as admin
	if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Write-Warning "This script must be run as an administrator. Please run PowerShell as an administrator and try again."
		break
	}
	
	Write-Host -ForegroundColor Yellow "Do the heist as normal and escape into the water"

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you in the water and ready to disable saving? (y/n)"
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
		
	Write-Host -ForegroundColor Yellow "Wait for the cutscene to finish, then switch to single player"

	$InputReceived = $false
	while (-not $InputReceived) {
		$Prompt = Read-Host -Prompt "Are you in single player and are you ready to remove the IP block? (y/n)"
		if ($Prompt -eq "y") {
			Write-Host -ForegroundColor DarkGreen "Removing firewall rule"
			Remove-NetFirewallRule -Name "Block GTA"
			Write-Host -ForegroundColor DarkGreen "Firewall rule removed"
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