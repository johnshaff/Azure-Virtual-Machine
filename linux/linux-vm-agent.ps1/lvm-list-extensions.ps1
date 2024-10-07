<#

COMMON EXTENSION PUBLISHERS:
- Microsoft.Azure.Monitor
- Microsoft.Azure.Security
- Microsoft.Azure.NetworkWatcher
- Microsoft.Azure.Diagnostics
- Microsoft.Azure.Extensions
- Microsoft.Azure.ActiveDirectory
- Microsoft.Azure.Applications

#>

# Define extension publisher
$extensionPublisher = "Microsoft.Azure.Extensions"

# Fetch the extension images and convert the JSON output to PowerShell objects
$extensions = az vm extension image list `
  --publisher $extensionPublisher `
  --output json | ConvertFrom-Json

# Group the extensions by Publisher and Extension, then select the latest version
$latestExtensions = $extensions | Group-Object -Property publisher, name | ForEach-Object {
    $_.Group | Sort-Object -Property version -Descending | Select-Object -First 1
}

# Display the results in a formatted table with renamed columns
$latestExtensions | Select-Object `
  @{Name="Publisher"; Expression={$_.publisher}}, `
  @{Name="Extension"; Expression={$_.name}}, `
  @{Name="Latest Version"; Expression={$_.version}} | Format-Table


Write-Host "Above is the latest version of each extension by publisher for your convenience. `
Please see below for a full list of older versions for each extension.`n" -ForegroundColor DarkGreen

# The following returns all versions of each extension by publisher
az vm extension image list `
  --publisher $extensionPublisher `
  --query "sort_by(sort_by(sort_by([].{Publisher:publisher, Extension:name, Version:version}, &Version), &Extension), &Publisher)" `
  --output table

Write-Host "`nThis script listed extension from the publisher '$extensionPublisher' and their versions. `
If you want to list extensions from another publisher, run the script lvm-list-extensions.ps1 `
and retrieve a publisher name and add it to the top of this script. `n" -ForegroundColor DarkBlue