
# Force non-terminating errors to be caught
$ErrorActionPreference = "Stop"

# Declare global variables
$resourceGroup = "vmAppTestRG"
$vmName = "linuxVM"
$applicationName = "apache2"

# Retrieve the VM configuration
$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName

# Filter out the gallery application you want to remove from the ApplicationProfile
$vm.ApplicationProfile.GalleryApplications = $vm.ApplicationProfile.GalleryApplications | Where-Object {
    $_.PackageReferenceId -notlike "*$applicationName*"
}

# Then update the VM configuration to apply the removal
Update-AzVM -ResourceGroupName $resourceGroup -VM $vm

# Check the vm for the removed application
Write-Host "VM application profile after removal:"
Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName | Select-Object -ExpandProperty ApplicationProfile