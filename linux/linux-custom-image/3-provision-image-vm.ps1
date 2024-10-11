# Force non-terminating errors to be caught
$ErrorActionPreference = "Stop"

#create a resource group
$resourceGroupName = "linuxRG"
$location = "EastUS"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Retrieve custom image ID from the shared image gallery
$imageRG = "linuxRG"  # Resource group where your custom image is stored
$imageDefName = "debian12"
$sigGalleryName = "linuxGallery"
$image = Get-AzGalleryImageVersion -ResourceGroupName $imageRG -GalleryName $sigGalleryName -GalleryImageDefinitionName $imageDefName
$imageId = $image.Id


#--------------------------------------------
# VIRUTAL MACHINE
#--------------------------------------------

$vmName = "debian12VM"
$nsgName = 'debian12VMNSG'

Write-Output "Creating $vmName in the $resourceGroupName resource group..."

try {
    az vm create --resource-group $resourceGroupName `
        --name $vmName `
        --image $imageId `
        --public-ip-sku "Standard" `
        --admin-username "azureuser" `
        --nsg $nsgName `
        --generate-ssh-keys | Out-String

    Write-Output "'$vmName' created successfully."
}
catch {
    Write-Error "Failed to create VM. Error: $_"
}

#--------------------------------------------
# NETWORKING
#--------------------------------------------

Write-Host "Adding inbound port rule for SSH on NSG..."

$ruleName = 'AllowHTTP'
$priority = 1010  # Ensure this priority doesn't conflict with existing rules
$description = 'Allow inbound HTTP traffic'

try {

    Add-AzNetworkSecurityRuleConfig `
        -NetworkSecurityGroup (Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName) `
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

