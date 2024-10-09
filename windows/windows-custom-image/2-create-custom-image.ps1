#---------------------------------------------
# ENVIRONMENT VARIABLES & MODULE INSTALLS
#---------------------------------------------

$context = Get-AzContext
$subscriptionID = $context.Subscription.Id
$resourceGroupName = "demoRG"
$location = "eastus"

# Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Add Azure PowerShell modules to support AzUserAssignedIdentity and Azure VM Image Builder
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object { Install-Module -Name $_ -AllowPrerelease }

#---------------------------------------------
# AUTHENTICATION
#---------------------------------------------

# setup role def names, these need to be unique
$timeInt = $(get-date -UFormat "%s")
$imageRoleDefName = "Azure Image Builder Image Def" + $timeInt
$identityName = "aibIdentity" + $timeInt

# Create the identity
New-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $identityName -Location $location

$identityNameResourceId = $(Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $identityName).Id
$identityNamePrincipalId = $(Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $identityName).PrincipalId

$aibRoleImageCreationUrl = "https://raw.githubusercontent.com/azure/azvmimagebuilder/main/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json"
$aibRoleImageCreationPath = "aibRoleImageCreation.json"

# Download the config
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing

((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>', "$subscriptionID") | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $resourceGroupName) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath

# Create a role definition
New-AzRoleDefinition -InputFile  ./aibRoleImageCreation.json

# Grant the role definition to the VM Image Builder service principal
New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$resourceGroupName"

#---------------------------------------------
# CREATE AZURE COMPUTE GALLERY AND IMAGE
#---------------------------------------------

$sigGalleryName = "windowsGallery" # Replace with your own gallery name
$imageDefName = "win10avd" # Replace with your own image definition name
$publisherName = "SHAFF" # Replace with your own publisher name

# Create the gallery
New-AzGallery -GalleryName $sigGalleryName -ResourceGroupName $resourceGroupName  -Location $location

# Create the gallery definition
New-AzGalleryImageDefinition -GalleryName $sigGalleryName -ResourceGroupName $resourceGroupName -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher $publisherName -Offer 'Windows' -Sku '10avd'

#---------------------------------------------
# PREPARE CUSTOM IMAGE TEMPLATE
#---------------------------------------------

# Download base template file
$templateFilePath = "baseImageTemplate.json"

# Distribution properties object name (runOutput). Gives you the properties of the managed image on completion
$runOutputName = "sigOutput"

# Replace placeholders in the template file
((Get-Content -path $templateFilePath -Raw) -replace '<subscriptionID>', $subscriptionID) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<rgName>', $resourceGroupName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<region>', $location) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<runOutputName>', $runOutputName) | Set-Content -Path $templateFilePath

((Get-Content -path $templateFilePath -Raw) -replace '<imageDefName>', $imageDefName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<sharedImageGalName>', $sigGalleryName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<region1>', $location) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>', $identityNameResourceId) | Set-Content -Path $templateFilePath


#---------------------------------------------
# SUBMIT THE IMAGE TEMPLATE
#---------------------------------------------

# Image template name
$imageTemplateName = "win10avdTemplate"

try {
    # Validate the template first
    $validationResult = az deployment group validate `
        --resource-group $resourceGroupName `
        --template-file $templateFilePath `
        --parameters api-version="2020-02-14" imageTemplateName=$imageTemplateName svclocation=$location `
        -o json

    # Convert the validation result to JSON for easy access
    $validationResultJson = $validationResult | ConvertFrom-Json

    # Check if validation succeeded
    if ($null -ne $validationResultJson -and $validationResultJson.properties.provisioningState -eq "Succeeded") {
        Write-Host "Template validation successful. Proceeding with submission..."

        # Submit the template
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterObject @{"api-version" = "2020-02-14"; "imageTemplateName" = $imageTemplateName; "svclocation" = $location }

        Write-Host "Template submitted successfully."

        # Wait for the template to be available after submission
        Start-Sleep -Seconds 30  # Delay to ensure the template is registered in Azure

        # Now check the template status
        $getStatus = Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName

        Write-Host "Build state: $($getStatus.LastRunStatusRunState)"
        Write-Host "Build message: $($getStatus.LastRunStatusMessage)"
        Write-Host "Build sub-state: $($getStatus.LastRunStatusRunSubState)"
    }
    else {
        Write-Host "Template validation failed. Please check the template for errors."
    }
}
catch {
    Write-Host "An error occurred during template submission or status check. Checking for more details..."

    if ($_ -like "*ResourceNotFound*") {
        Write-Host "Error: The image template '$imageTemplateName' was not found in resource group '$resourceGroupName'."
    }
    else {
        # General error handling
        Write-Host "Error: $($_.Exception.Message)"
    }
}

#---------------------------------------------
# BUILD THE IMAGE
#---------------------------------------------

# Start the image build
Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -NoWait

# Initialize status check
$buildComplete = $false

# Check the status of the build periodically
while (-not $buildComplete) {
    # Get the status of the build
    $getStatus = Get-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName

    # Display the current run state
    Write-Host "Build state: $($getStatus.LastRunStatusRunState)"
    Write-Host "Build message: $($getStatus.LastRunStatusMessage)"
    Write-Host "Build sub-state: $($getStatus.LastRunStatusRunSubState)"

    # Check if the build is complete
    if ($getStatus.LastRunStatusRunState -eq "Succeeded" -or $getStatus.LastRunStatusRunState -eq "Failed") {
        $buildComplete = $true
    }
    else {
        # Wait for 60 seconds before checking again
        Start-Sleep -Seconds 30
    }
}

# Display final status
Write-Host "Build completed with state: $($getStatus.LastRunStatusRunState)"
Write-Host "Final message: $($getStatus.LastRunStatusMessage)"