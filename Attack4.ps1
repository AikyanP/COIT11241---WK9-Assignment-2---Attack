# Get computer information
$computerInfo = @{
    "ComputerName" = $env:COMPUTERNAME
    "Manufacturer" = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
    "Model" = (Get-WmiObject -Class Win32_ComputerSystem).Model
    "Processor" = (Get-WmiObject -Class Win32_Processor).Name
    "MemoryGB" = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    "OS" = (Get-WmiObject -Class Win32_OperatingSystem).Caption
}

# Get local drives information
$drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, VolumeName, Size, FreeSpace

# Get local user information
$localUsers = Get-WmiObject -Class Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true } | Select-Object Name, Disabled, Lockout, PasswordChangeable, PasswordExpires, LastLogon, PasswordRequired, Description, SID

# Display computer information
Write-Output "Computer Information:"
$computerInfo.GetEnumerator() | ForEach-Object {
    Write-Output "$($_.Key): $($_.Value)"
}

# Display local drives information
Write-Output "Local Drives Information:"
$drives | ForEach-Object {
    Write-Output "Drive: $($_.DeviceID)"
    Write-Output "Volume Name: $($_.VolumeName)"
    Write-Output "Total Size: $($_.Size) bytes"
    Write-Output "Free Space: $($_.FreeSpace) bytes"
    Write-Output "----------------------"
}

# Display local user information
Write-Output "Local User Information:"
$localUsers | ForEach-Object {
    Write-Output "Username: $($_.Name)"
    Write-Output "Account Disabled: $($_.Disabled)"
    Write-Output "Account Locked Out: $($_.Lockout)"
    Write-Output "Password Changeable: $($_.PasswordChangeable)"
    Write-Output "Password Expires: $($_.PasswordExpires)"
    Write-Output "Last Logon: $($_.LastLogon)"
    Write-Output "Password Required: $($_.PasswordRequired)"
    Write-Output "Description: $($_.Description)"
    Write-Output "SID: $($_.SID)"
    Write-Output "----------------------"
}
