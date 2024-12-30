# Define the base folder and subfolder names
$baseFolder = "C:\Sandbox" # Replace this location if needed.
$subfolders = @("ConfigFiles", "SandboxFiles", "WSB")

# Create the base folder if it doesn't exist
if (-not (Test-Path -Path $baseFolder)) {
    New-Item -Path $baseFolder -ItemType Directory
}

# Create the subfolders
foreach ($subfolder in $subfolders) {
    $subfolderPath = Join-Path -Path $baseFolder -ChildPath $subfolder
    if (-not (Test-Path -Path $subfolderPath)) {
        New-Item -Path $subfolderPath -ItemType Directory
    }
}
