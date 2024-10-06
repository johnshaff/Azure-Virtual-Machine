#The following returns the latest version of each extension by publisher

# Fetch the extension images and convert the JSON output to PowerShell objects
$extensions = az vm extension image list `
  --publisher Microsoft.Azure.Monitor `
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
  --publisher Microsoft.Azure.Monitor `
  --query "sort_by(sort_by(sort_by([].{Publisher:publisher, Extension:name, Version:version}, &Version), &Extension), &Publisher)" `
  --output table