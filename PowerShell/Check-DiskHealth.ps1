# Last updated
# 2020-07-20

# Maintainer
# 77cla77@gmail.com

# Description
# Used by Checkmk to monitor the physical disks on a Windows device and alert if there's any disk failures

# Get all the disks
$Disks = Get-PhysicalDisk | Select-Object FriendlyName,HealthStatus,SerialNumber

# Variable to increment
$i = 1

foreach ($Disk in $Disks) {

    if ($Disk.HealthStatus -eq "Healthy") {
        # If the disks are healthy, return OK
        $Status = "0"
        $StatusText = "Disk '" + $Disk.FriendlyName + "' with serial number '" + $Disk.SerialNumber + "' is healthy"
        }

    else {
        # If the disks aren't healthy, return ERROR
        $Status = "2"
        $StatusText = "Disk '" + $Disk.FriendlyName + "' with serial number '" + $Disk.SerialNumber + "' is NOT healthy! Check the array!"
        }

    # Write the status of each disk to the console
	# https://checkmk.com/cms_localchecks.html
	# This must be in the format
	# 0 myservice myvalue=73;80;90  My output text which may contain spaces
    $Result = $Status + " " + "DiskHealthCheck-$i" + " " + "-" + " " + $StatusText

    # Increment $i so that the service name is unique
    $i++

    # Write the output for cmk to collect
    Write-Host $Result

    }