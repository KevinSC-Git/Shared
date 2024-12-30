# Define Output Directory and Host Folders
$OutputDirectory = "C:\Sandbox\WSB" # Adjust this location if needed.
$HostFolders = @("C:\Temp", "C:\Sandbox") # Add more folders as needed.

# Ensure output directory exists
if (-not (Test-Path $OutputDirectory)) {
    New-Item -Path $OutputDirectory -ItemType Directory -Force
}

# Read template and inject multiple host folders
$template = Get-Content .\sandbox.wsb.template

# Build <MappedFolders> block dynamically
$mappedFolders = ""
foreach ($folder in $HostFolders) {
    $mappedFolders += @"
    <MappedFolder>
      <HostFolder>$folder</HostFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
"@
}

# Replace __MAPPED_FOLDERS__ placeholder with the dynamic block
$configContent = $template -replace '__MAPPED_FOLDERS__', $mappedFolders

# Save the updated configuration file
Set-Content "$OutputDirectory\Default.wsb" $configContent # WSB-file name can be changed as needed.

Write-Output "sandbox.wsb file created successfully in $OutputDirectory with multiple host folders."
