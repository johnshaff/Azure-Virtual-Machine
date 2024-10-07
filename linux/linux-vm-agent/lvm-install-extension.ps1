# Define the resource group and VM name
$resourceGroupName = "linuxRG"
$vmName = "linuxVM"

# Use Azure Linux Extensions to install the Log Analytics agent
az vm extension set `
    --publisher Microsoft.Azure.Monitor `
    --name AzureMonitorLinuxAgent `
    --resource-group $resourceGroupName `
    --vm-name $vmName
