# 1. Find the EyeChip (You can search by FriendlyName or Hardware ID)
$eyechip = Get-PnpDevice -FriendlyName "*EyeChip*" -ErrorAction SilentlyContinue
# Alternative if FriendlyName varies:
# $eyechip = Get-PnpDevice | Where-Object { $_.InstanceId -match "VID_2104&PID_0313" }

if (-not $eyechip) {
    Write-Warning "Tobii EyeChip not found in device manager."
    exit 1
}

Write-Host "Found EyeChip: $($eyechip.FriendlyName)"
Write-Host "Device ID: $($eyechip.InstanceId)"

# 2. Extract the Parent Instance ID directly from the device properties
# This natively traverses one level up the hardware tree
$parentProperty = Get-PnpDeviceProperty -InstanceId $eyechip.InstanceId -KeyName "DEVPKEY_Device_Parent"
$parentId = $parentProperty.Data

if (-not $parentId) {
    Write-Error "Could not determine parent hub ID."
    exit 1
}

# 3. Get the parent device object so we can see what we are resetting
$parentHub = Get-PnpDevice -InstanceId $parentId
Write-Host "Found Parent Hub: $($parentHub.FriendlyName)"
Write-Host "Parent Hub ID: $($parentHub.InstanceId)"

# Reset hub
Restart-PnpDevice -InstanceId $parentHub.InstanceId -Force

if ($LASTEXITCODE -eq 0) {
    Write-Host "Hub reset successfully." -ForegroundColor Green
} else {
    Write-Warning "Restarting device returned an error or requires elevated permissions."
}
