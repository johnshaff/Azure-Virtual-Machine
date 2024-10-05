

# Declare global variables
$resourceGroupName = "linuxRG"
$location = "EastUS"
$vmName = "linuxVM"
$nsgName = 'linuxVMNSG'

# Create a new resource group
Write-Output "Creating resource group '$resourceGroupName' in $location..."
New-AzResourceGroup -Name $resourceGroupName -Location $location

#--------------------------------------------
# VIRTUAL MACHINE
#--------------------------------------------


# Create a Linux VM using Azure CLI
Write-Output "Creating Linux VM in the '$resourceGroupName' resource group..."

try {
    az vm create --resource-group $resourceGroupName `
                 --name $vmName `
                 --image "Debian11" `
                 --public-ip-sku "Standard" `
                 --admin-username "azureuser" `
                 --nsg $nsgName `
                 --generate-ssh-keys | Out-String

    Write-Output "'$vmName' created successfully."
} catch {
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
} catch {
    Write-Error "Failed to add inbound port rule for SSH. Error: $_"
}

#--------------------------------------------
# APPLICATION INSTALLATION
#--------------------------------------------


# Install Apache2 on the newly created VM
Write-Output "Installing Apache2 on '$vmName'..."

try {
    az vm run-command invoke --command-id RunShellScript --name $vmName `
                             --resource-group $resourceGroupName `
                             --scripts "sudo apt update && sudo apt install -y apache2" | Out-String
    Write-Output "Apache2 installed successfully on '$vmName'."
} catch {
    Write-Error "Failed to install Apache2. Error: $_"
}
