#--------------------------------------------
# CREATE A TEST VM
#--------------------------------------------

# Force non-terminating errors to be caught
$ErrorActionPreference = "Stop"

# Declare global variables
$resourceGroup = "vmAppTestRG"
$vmName = "linuxVM"
$location = "eastus"
$nsgName = "linuxVMNSG"

Create a new resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

try {
    az vm create `
        --resource-group $resourceGroup `
        --name $vmName `
        --image "debian:debian-12:12:latest" `
        --public-ip-sku "Standard" `
        --admin-username "azureuser" `
        --nsg $nsgName `
        --generate-ssh-keys | Out-String
}
catch {
    Write-Error "Failed to create VM. Error: $_"
}

Write-Output "'$vmName' created successfully."

#--------------------------------------------
# NETWORKING
#--------------------------------------------

Write-Host "Adding inbound port rule for SSH on NSG..."

$ruleName = 'AllowHTTP'
$priority = 1010  # Ensure this priority doesn't conflict with existing rules
$description = 'Allow inbound HTTP traffic'

try {

    Add-AzNetworkSecurityRuleConfig `
        -NetworkSecurityGroup (Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Name $nsgName) `
        -Name $ruleName `
        -Description $description `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority $priority `
        -SourceAddressPrefix 'Internet' `
        -SourcePortRange '*' `
        -DestinationAddressPrefix '*' `
        -DestinationPortRange 80 | Set-AzNetworkSecurityGroup

    Write-Output "Inbound port rule for SSH added successfully."
}
catch {
    Write-Error "Failed to add inbound port rule for SSH. Error: $_"
}


#--------------------------------------------
# ADD THE APPLICATION TO THE VM
#--------------------------------------------

$galleryName = "linuxAppGallery"   # The name of the Azure Compute Gallery where your application is stored
$galleryRG = "linuxRG"              # The resource group where the gallery is stored
$applicationName = "apache2"   # The name of the application you want to add to the VM
$applicationVersion = "2.4.62"    # The version of the application you want to add (e.g., version 1.0.0)

# Retrieve the VM configuration
$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName

# This gets the application version information from the Azure Compute Gallery, which includes the ID needed for the next step
$applicationVersion = Get-AzGalleryApplicationVersion `
    -GalleryApplicationName $applicationName `
    -GalleryName $galleryName `
    -Name $applicationVersion `
    -ResourceGroupName $galleryRG

# The package ID is used to uniquely identify the application version that needs to be added to the VM
$packageId = $applicationVersion.Id

# This creates the gallery application object using the package ID, which will be attached to the VM
$app = New-AzVmGalleryApplication -PackageReferenceId $packageId

# This command adds the application to the VM configuration
# The param `-TreatFailureAsDeploymentFailure` is a switch type, and ensures that if the application fails to install, 
# the entire deployment is considered a failure
Add-AzVmGalleryApplication `
    -VM $vm `
    -GalleryApplication $app `
    -TreatFailureAsDeploymentFailure

# Update the VM configuration on Azure to apply the changes (adding the application)
Update-AzVM -ResourceGroupName $resourceGroup -VM $vm
