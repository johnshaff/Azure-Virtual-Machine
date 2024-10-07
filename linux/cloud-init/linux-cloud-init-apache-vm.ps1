# Declare global variables
$resourceGroupName = "linuxRG"
$location = "EastUS"
$vmName = "linuxVM"
$cloudInitFile = "cloud-init.txt"

# Create a new resource group
Write-Output "Creating resource group '$resourceGroupName' in $location..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

#--------------------------------------------
# VIRTUAL MACHINE
#--------------------------------------------

az vm create `
    --resource-group $resourceGroupName `
    --name $vmName `
    --image Canonical:UbuntuServer:19_10-daily-gen2:latest `
    --custom-data $cloudInitFile `
    --generate-ssh-keys