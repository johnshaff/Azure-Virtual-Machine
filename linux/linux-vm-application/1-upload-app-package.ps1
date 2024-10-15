
#-----------------------------------------------------------
# CREATE A BLOB CONTAINER IN YOUR AZURE STORAGE ACCOUNT
#-----------------------------------------------------------

# Force non-terminating errors to be caught
$ErrorActionPreference = "Stop"

# Define storage account details
$resourceGroup = "az-900"
$storageAccountName = "<your-storage-account-name>"

# Allow public access
az storage account update `
    --name $storageAccountName `
    --resource-group $resourceGroup `
    --allow-blob-public-access true

# Retrieve the existing storage account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName

# Get the context of the existing storage account
$context = $storageAccount.Context

# Create a new blob container with public access at the Blob level
$containerName = 'linux-app-blobs'
try {
    $null = New-AzStorageContainer -Name $containerName -Context $context -PublicAccess Container -ErrorAction Stop
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
Write-Host "$containerName container created successfully"

# check if the container was created it is publicly accessible
Get-AzStorageContainer -Context $context | Select-Object -Property Name
az storage container show-permission --account-name $storageAccountName --name $containerName


#-----------------------------------------------------------
# UPLOAD YOUR APP PACKAGE TO THE BLOB CONTAINER
#-----------------------------------------------------------

# Path to the local file you want to upload
$inputFile = '/Users/johnshaff/Downloads/apache2-package.tar.gz'

# Upload the padded file to the blob container
$BlobUploadParams = @{
    File             = $inputFile
    Container        = $containerName
    Blob             = "apache2-package.tar.gz"
    Context          = $context
    StandardBlobTier = 'Hot'
}
Set-AzStorageBlobContent @BlobUploadParams

# List the blobs in the container to verify upload
Get-AzStorageBlob `
    -Container $containerName `
    -Context $context | Select-Object -Property Name