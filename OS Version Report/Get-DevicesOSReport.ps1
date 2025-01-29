function Write-Log {
    param (
        [string]$message
    )

    # Try to get the directory where the script is running
    $scriptDirectory = $PSScriptRoot
    if (-not $scriptDirectory) {
        $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
    }

    # Define the Logs folder path
    $logsDirectory = Join-Path -Path $scriptDirectory -ChildPath "Logs"

    # Check if the Logs folder exists, if not, create it
    if (-Not (Test-Path -Path $logsDirectory)) {
        New-Item -ItemType Directory -Path $logsDirectory | Out-Null
    }

    # Define the log file path
    $logFile = Join-Path -Path $logsDirectory -ChildPath "logfile.log"

    # Create the log message with a timestamp
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $logMessage = "$timestamp - $message"

    # Write the log message to the file and output to the console
    $logMessage | Out-File -Append -FilePath $logFile
    Write-Output $logMessage  # Optionally, display the log message on the console
}

function Set-ContentWithRetry {
    param (
        [string]$Path,
        [string]$Value,
        [int]$RetryCount = 5,
        [int]$Delay = 1000
    )

    for ($i = 0; $i -lt $RetryCount; $i++) {
        try {
            Set-Content -Path $Path -Value $Value -Encoding UTF8
            return
        } catch [System.IO.IOException] {
            Start-Sleep -Milliseconds $Delay
        }
    }

    throw "Failed to write to file '$Path' after $RetryCount attempts."
}

# Start the log
Write-Log "Script started."
Write-Log "Log file path: $LogFile"

# Connect to Microsoft Graph interactively
Write-Log "Connecting to Microsoft Graph..."
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"
Write-Log "Successfully connected to Microsoft Graph."

# Define the OS version map directly in the script
$OSVersionMap = @{
    "0.0.0.0" = "Unknown OS Version"
    "10.0" = "Unknown OS Version"
    "10.0.14393" = "Windows Server 2016"
    "10.0.10240" = "Windows Server 2012 R2"
    "6.1.7601" = "Windows Server 2008 R2, Service Pack 1"
    "6.3.9600" = "Windows Server 2012 R2 / Windows 8.1"
    "6.2.9200" = "Windows 8 (RTM)"
    "6.1.7600" = "Windows 7 (RTM)"
    "5.1.2600" = "Windows XP (RTM)"
    "5.1.2600.5512" = "Windows XP (Service Pack 3)"
    "5.0.2195" = "Windows 2000"
    "5.2.3790" = "Windows Server 2003"
    "10.0.17134.1304" = "Windows 10 (1803)"
    "10.0.17763.6532" = "Windows Server 2019"
    "10.0.18363.1379" = "Windows 10 (1909)"
    "10.0.18363.1679" = "Windows 10 (1909)"
    "10.0.18363.2274" = "Windows 10 (1909)"
    "10.0.18363.778" = "Windows 10 (1909)"
    "10.0.19042.1466" = "Windows 10 (20H2)"
    "10.0.19042.1586" = "Windows 10 (20H2)"
    "10.0.19042.1826" = "Windows 10 (20H2)"
    "10.0.19042.2965" = "Windows 10 (20H2)"
    "10.0.19043.985" = "Windows 10 (21H1)"
    "10.0.19044" = "Windows 10 (21H2)"
    "10.0.19044.1466" = "Windows 10 (21H2)"
    "10.0.19044.1826" = "Windows 10 (21H2)"
    "10.0.19044.3086" = "Windows 10 (21H2)"
    "10.0.19044.3930" = "Windows 10 (21H2)"
    "10.0.19044.1766" = "Windows 10 (21H2)"
    "10.0.19044.5131" = "Windows 10 (21H2)"
    "10.0.19044.2364" = "Windows 10 (21H2)"
    "10.0.19044.5371" = "Windows 10 (21H2)"
    "10.0.19044.5247" = "Windows 10 (21H2)"
    "10.0.19044.5011" = "Windows 10 (21H2)"
    "10.0.19045" = "Windows 10 (22H2)"
    "10.0.19045.2364" = "Windows 10 (22H2)"
    "10.0.19045.2486" = "Windows 10 (22H2)"
    "10.0.19045.2604" = "Windows 10 (22H2)"
    "10.0.19045.2728" = "Windows 10 (22H2)"
    "10.0.19045.2846" = "Windows 10 (22H2)"
    "10.0.19045.2965" = "Windows 10 (22H2)"
    "10.0.19045.3086" = "Windows 10 (22H2)"
    "10.0.19045.3208" = "Windows 10 (22H2)"
    "10.0.19045.3448" = "Windows 10 (22H2)"
    "10.0.19045.3570" = "Windows 10 (22H2)"
    "10.0.19045.3693" = "Windows 10 (22H2)"
    "10.0.19045.3930" = "Windows 10 (22H2)"
    "10.0.19045.4046" = "Windows 10 (22H2)"
    "10.0.19045.4170" = "Windows 10 (22H2)"
    "10.0.19045.4291" = "Windows 10 (22H2)"
    "10.0.19045.4355" = "Windows 10 (22H2)"
    "10.0.19045.4412" = "Windows 10 (22H2)"
    "10.0.19045.4474" = "Windows 10 (22H2)"
    "10.0.19045.4529" = "Windows 10 (22H2)"
    "10.0.19045.4651" = "Windows 10 (22H2)"
    "10.0.19045.4780" = "Windows 10 (22H2)"
    "10.0.19045.4894" = "Windows 10 (22H2)"
    "10.0.19045.5011" = "Windows 10 (22H2)"
    "10.0.19045.5131" = "Windows 10 (22H2)"
    "10.0.19045.5247" = "Windows 10 (22H2)"
    "10.0.19045.5371" = "Windows 10 (22H2)"
    "10.0.20348" = "Windows Server 2022"
    "10.0.22000.1817" = "Windows 11 (21H2)"
    "10.0.22000.2538" = "Windows 11 (21H2)"
    "10.0.22621.1848" = "Windows 11 (22H2)"
    "10.0.22621.3007" = "Windows 11 (22H2)"
    "10.0.22621.3737" = "Windows 11 (22H2)"
    "10.0.22621.3880" = "Windows 11 (22H2)"
    "10.0.22621.4037" = "Windows 11 (22H2)"
    "10.0.22621.4169" = "Windows 11 (22H2)"
    "10.0.22621.4317" = "Windows 11 (22H2)"
    "10.0.22621.4460" = "Windows 11 (22H2)"
    "10.0.22621.4602" = "Windows 11 (22H2)"
    "10.0.22621.4751" = "Windows 11 (22H2)"
    "10.0.22631.2428" = "Windows 11 (23H2)"
    "10.0.22631.2861" = "Windows 11 (23H2)"
    "10.0.22631.3296" = "Windows 11 (23H2)"
    "10.0.22631.3447" = "Windows 11 (23H2)"
    "10.0.22631.3593" = "Windows 11 (23H2)"
    "10.0.22631.3737" = "Windows 11 (23H2)"
    "10.0.22631.3880" = "Windows 11 (23H2)"
    "10.0.22631.3958" = "Windows 11 (23H2)"
    "10.0.22631.4037" = "Windows 11 (23H2)"
    "10.0.22631.4169" = "Windows 11 (23H2)"
    "10.0.22631.4317" = "Windows 11 (23H2)"
    "10.0.22631.4391" = "Windows 11 (23H2)"
    "10.0.22631.4529" = "Windows 11 (23H2)"
    "10.0.22631.4651" = "Windows 11 (23H2)"
    "10.0.22631.4780" = "Windows 11 (23H2)"
    "10.0.22631.4894" = "Windows 11 (23H2)"
    "10.0.22631.5011" = "Windows 11 (23H2)"
    "10.0.22631.5131" = "Windows 11 (23H2)"
    "10.0.22631.5247" = "Windows 11 (23H2)"
    "10.0.22631.5371" = "Windows 11 (23H2)"
    "10.0.22631.4460" = "Windows 11 (23H2)"
    "10.0.22631.4602" = "Windows 11 (23H2)"
    "10.0.22631.4751" = "Windows 11 (23H2)"
    "10.0.26100.1742" = "Windows 11 (24H2)"
    "10.0.26100.2033" = "Windows 11 (24H2)"
    "10.0.26100.2314" = "Windows 11 (24H2)"
    "10.0.26100.2605" = "Windows 11 (24H2)"
    "10.0.26100.2894" = "Windows 11 (24H2)"
}

# Log the OSVersionMap content to check if it’s being loaded correctly
# Write-Log "OSVersionMap content: $($OSVersionMap | ConvertTo-Json -Depth 3)"

# Check if OSVersionMap is empty
if (-not $OSVersionMap) {
    Write-Log "Failed to load OS version map. Exiting script."
    Write-Host "Failed to load OS version map. Exiting script." -ForegroundColor Red
    return
}
Write-Log "Successfully loaded OS version map."

# Base URL for Windows devices
$BaseUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=operatingSystem eq 'Windows'"

# Initialize variables for pagination
$Url = $BaseUrl  # Base URL for the API request
$Devices = @()   # Initialize the devices array

# Fetch all devices
Write-Log "Fetching all Windows devices..."
do {
    try {
        # Make the API request to Microsoft Graph
        $Response = Invoke-MgGraphRequest -Uri $Url -Method Get

        if ($Response.value) {
            # Filter only Windows devices (if necessary)
            $WindowsDevices = $Response.value | Where-Object { $_.operatingSystem -match "Windows" }

            # Append the Windows devices to the Devices array
            $Devices += $WindowsDevices

            Write-Log "Fetched $($WindowsDevices.Count) Windows devices. Total so far: $($Devices.Count)"
        } else {
            Write-Log "No devices fetched in this response."
        }

        # Check if the next page is available, using the @odata.nextLink
        $Url = $Response.'@odata.nextLink'

    } catch {
        Write-Log "Error fetching devices: $_"
    }
} while ($Url -ne $null)

# Log with total devices fetched
Write-Log "Total Windows devices fetched from API: $($Devices.Count)"


# Apply the second filter for company-owned devices
$CompanyOwnedDevices = $Devices | Where-Object { $_.managedDeviceOwnerType -eq 'company' }
Write-Log "Total company-owned devices: $($CompanyOwnedDevices.Count)"

# If no company-owned devices exist, exit early
if ($CompanyOwnedDevices.Count -eq 0) {
    Write-Log "No company-owned devices found. Exiting script."
    Write-Host "No company-owned devices found. Exiting script." -ForegroundColor Yellow
    return
}

# Generate HTML report
Write-Log "Generating HTML report..."

# Initialize HTML report content
$HtmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intune Company-Owned Devices Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Intune Company-Owned Devices Report</h1>
    <p>Total Company-Owned Windows Devices: ${($CompanyOwnedDevices.Count)}</p>
    <table>
        <thead>
            <tr>
                <th>Device Name</th>
                <th>Primary User</th>
                <th>OS Version</th>
                <th>OS Build</th>
                <th>Last Sync Date</th>
            </tr>
        </thead>
        <tbody>
"@

# Initialize a hashtable to store OS version counts
$OSVersionCounters = @{}

foreach ($Device in $CompanyOwnedDevices) {
    $DeviceName = $Device.deviceName
    $OsVersion = $Device.osVersion
    $PrimaryUser = $Device.userPrincipalName
    $LastSyncDate = $Device.lastSyncDateTime

    # Try to match the full OS version in the map (Exact Match)
    $FriendlyOSVersion = $OSVersionMap[$OsVersion]

    # If no exact match is found, attempt partial matching
    if (-not $FriendlyOSVersion) {
        Write-Log "Exact match not found for $OsVersion, attempting partial match..."
        $FriendlyOSVersion = $OSVersionMap.Keys | Where-Object { $OsVersion.StartsWith($_) } | Sort-Object { $_.Length } | Select-Object -First 1
    }

    # If no match is found, fallback to "Unknown OS Version"
    if (-not $FriendlyOSVersion) {
        $FriendlyOSVersion = "Unknown OS Version ($OsVersion)"
    }

    # Increment the count for this OS version in the hashtable
    if ($OSVersionCounters.ContainsKey($FriendlyOSVersion)) {
        $OSVersionCounters[$FriendlyOSVersion] += 1
    } else {
        $OSVersionCounters[$FriendlyOSVersion] = 1
    }

    # Log the result
    Write-Log "Device: $DeviceName, OS: $OsVersion, Friendly OS: $FriendlyOSVersion"

    # Add device to HTML content
    $HtmlContent += @"
        <tr>
            <td>$DeviceName</td>
            <td>$PrimaryUser</td>
            <td>$FriendlyOSVersion</td>
            <td>$OsVersion</td>
            <td>$LastSyncDate</td>
        </tr>
"@
}

# Generate summary of OS version counts
$OSVersionSummary = "<h2>OS Version Summary</h2><ul>"
foreach ($Key in $OSVersionCounters.Keys) {
    $OSVersionSummary += "<li>$Key : $($OSVersionCounters[$Key]) device(s)</li>"
}
$OSVersionSummary += "</ul>"

# Finalize HTML content
$HtmlContent += @"
        </tbody>
    </table>
    $OSVersionSummary
</body>
</html>
"@

# Output the final HTML report file
$OutputPath = "$scriptDir\IntuneCompanyOwnedDevicesReport.html"
Set-ContentWithRetry -Path $OutputPath -Value $HtmlContent -Encoding UTF8

Write-Log "HTML report generated successfully at: $OutputPath"

# Disconnect from Microsoft Graph
Write-Log "Disconnecting from Microsoft Graph..."
Disconnect-MgGraph
Write-Log "Disconnected from Microsoft Graph."

# End the log
Write-Log "Script completed."