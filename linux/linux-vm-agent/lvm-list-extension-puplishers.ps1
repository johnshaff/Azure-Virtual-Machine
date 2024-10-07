
# Fetch the extension images and convert the JSON output to PowerShell objects
$extensions = az vm extension image list --output json | ConvertFrom-Json

# Group by publisher and select unique publishers
$uniquePublishers = $extensions | Select-Object -ExpandProperty publisher | Sort-Object -Unique

# Display the unique publishers in a formatted table with a custom column name
$uniquePublishers | Select-Object @{Name = "Azure Extension Publishers"; Expression = { $_ } } | Format-Table

