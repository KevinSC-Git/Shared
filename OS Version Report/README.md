# Intune Company-Owned Devices Report Script

## Overview
This PowerShell script retrieves a list of **company-owned Windows devices** from Microsoft Intune using the Microsoft Graph API. 
It maps OS versions to friendly names and generates an **HTML report** containing:
- **Device Name**
- **OS Version**
- **OS Build**
- **Primary User**
- **Last Sync Date**

## Features
- Connects securely to **Microsoft Graph API**.
- Filters **company-owned** Windows devices.
- Matches OS versions to **friendly names** using a predefined mapping.
- Generates a **detailed HTML report** summarizing device information.
- Implements **retry logic** for file writes to ensure reliability.
- Logs all actions to a dedicated log file for troubleshooting.

## Prerequisites
- Install **Microsoft Graph PowerShell module** (`Microsoft.Graph`).
- Ensure the user has **sufficient permissions** (`DeviceManagementManagedDevices.Read.All`).
- Run PowerShell with **administrator privileges**.

## How to use
```powershell
# Run the script
.\Get-IntuneCompanyOwnedDevices.ps1
```

The HTML report will be saved in the script's directory, and logs will be stored in a Logs folder.

## Example Output
The generated HTML report contains:

![image](https://github.com/user-attachments/assets/bb502cb3-82ce-4f55-b744-0f8abc1dc79a)


## Logging
The script logs execution details to Logs/logfile.log, capturing:
- **Start and completion times**
- **API call results**
- **Errors and retries**
- **OS version mappings**

## Notes
The script disconnects from Microsoft Graph after execution.
Ensure Graph API permissions are assigned before running the script.
Modify $OSVersionMap to include new OS versions if needed.

## Disclaimer
This script is **free to use and modify** for personal or organizational purposes. 
However, it is provided **as is**, without any warranties or guarantees.  
  
- The author is **not responsible** for any errors, issues, data loss, or unintended consequences resulting from the use of this script.  
- Users should **test the script** in a safe environment before deploying it in production.  
- Use at your **own risk**.  

By using this script, you accept full responsibility for its execution and any modifications made.
