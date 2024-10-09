
#create a resource group
$resourceGroupName = "windowsRG"
$location = "EastUS"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Retrieve custom image ID from the shared image gallery
$imageRG = "demoRG"  # Resource group where your custom image is stored
$imageDefName = "win10avd"
$sigGalleryName = "windowsGallery"
$image = Get-AzGalleryImageVersion -ResourceGroupName $imageRG -GalleryName $sigGalleryName -GalleryImageDefinitionName $imageDefName
$imageId = $image.Id

# User credentials
$securePassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("adminuser", $securePassword)

# VM naming
$vmName = "Win10VM"
$vnetName = "Win10VNET"
$subnetName = "web"
$nsgName = "Win10_NetworkSecurityGroup"
$publicIpName = "Win10_PublicIpAddress"


# Create a new VM
New-AzVm `
    -ResourceGroupName $resourceGroupName `
    -Name $vmName `
    -Location $location `
    -Image $imageId `
    -Size "Standard_D2s_v3" `
    -VirtualNetworkName $vnetName `
    -AddressPrefix "10.0.0.0/16" `
    -SubnetName $subnetName `
    -SubnetAddressPrefix "10.0.0.0/24" `
    -SecurityGroupName $nsgName `
    -PublicIpAddressName $publicIpName `
    -OpenPorts 80, 3389, 22 `
    -Credential $credential `
    -Zone 1

Write-Host "Open Windows Remote Desktop app and add the following public IP address to connect to your VM:"
Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object IpAddress
