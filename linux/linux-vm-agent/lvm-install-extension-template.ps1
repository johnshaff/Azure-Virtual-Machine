# Define variables
$resourceGroupName = "linuxRG"
$vmName = "linuxVM"
$templateFileName = "lvm-extension-template.json"
$workspaceName = "myLogAnalyticsWorkspace"
$location = "eastus"

# -------------------------------------------------------------
# CREATE LOG ANALYTICS WORKSPACE FOR THE AZURE MONITOR AGENT
# -------------------------------------------------------------

# Create the Log Analytics workspace
az monitor log-analytics workspace create `
    --resource-group $resourceGroupName `
    --workspace-name $workspaceName `
    --location $location

# Retrieve the workspace Resource ID
$workspaceResourceId = (az monitor log-analytics workspace show `
        --resource-group $resourceGroupName `
        --workspace-name $workspaceName `
        --query id -o tsv)

# Output the workspace Resource ID
Write-Host "Log Analytics Workspace Resource ID: $workspaceResourceId"

# -------------------------------------------------------------
# DEPLOY THE AZURE MONITOR AGENT USING AN ARM TEMPLATE
# -------------------------------------------------------------

try {
    # Attempt to validate the ARM template
    az deployment group validate `
        --resource-group $resourceGroupName `
        --template-file $templateFileName `
        --parameters vmName=$vmName `
        workspaceName=$workspaceName `
        workspaceResourceId=$workspaceResourceId `
        -o none  # Suppress output for clarity

    # If validation succeeds, proceed to deployment
    az deployment group create `
        --resource-group $resourceGroupName `
        --template-file $templateFileName `
        --parameters vmName=$vmName `
        workspaceName=$workspaceName `
        workspaceResourceId=$workspaceResourceId
}
catch {
    # If deployment fails, output an error message
    Write-Host "Deployment failed. Operation aborted."
    Write-Host "Error details: $_"
}

# Check the status of the deployment
az vm extension list `
  --resource-group $resourceGroupName `
  --vm-name $vmName `
  --output table