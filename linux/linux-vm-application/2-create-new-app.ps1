
#---------------------------------------------
# CREATE NEW AZURE COMPUTE GALLERY 
#---------------------------------------------

$galleryName = "linuxAppGallery" # Replace with your own gallery name
$resourceGroup = "linuxRG" # Replace with your own resource group name
$location = "eastus" # Replace with your own location

try {
    # Create the gallery
    New-AzGallery -GalleryName $galleryName -ResourceGroupName $resourceGroup -Location $location
    Write-Host "'$galleryName' created successfully."
} 
catch {
    Write-Host "An error occurred: $_"
}


#-----------------------------------------------------------
# CREATE THE AZURE GALLERY APPLICATION
#-----------------------------------------------------------

$applicationName = "apache2"

New-AzGalleryApplication `
    -ResourceGroupName $resourceGroup `
    -GalleryName $galleryName `
    -Location $location `
    -Name $applicationName `
    -SupportedOSType Linux `
    -Description "Apache2 web server for Debian 12"


#-----------------------------------------------------------
# ADD APP BLOB TO GALLERY APPLICATION
#-----------------------------------------------------------

# Get blob container URL
$storageAccountName = "storageaccount77380" # Replace with your own storage account name
$containerName = "linux-app-blobs" # Replace with your own container name
$blobName = "apache2-package.tar.gz" # Replace with your own blob name

$blobUrl = "https://$storageAccountName.blob.core.windows.net/$containerName/$blobName"

$applicationVersion = "2.4.62"

# Add the blob to the gallery application
New-AzGalleryApplicationVersion `
    -ResourceGroupName $resourceGroup `
    -GalleryName $galleryName `
    -GalleryApplicationName $applicationName `
    -Name $applicationVersion `
    -PackageFileLink $blobUrl `
    -Location $location `
    -Install "sudo wget $blobUrl -O /tmp/apache2-package.tar.gz && sudo tar -xzvf /tmp/apache2-package.tar.gz -C /tmp && sudo dpkg -i /tmp/*.deb > /tmp/install.log 2>&1" `
    -Remove "sudo rm -f /tmp/apache2-package.tar.gz /tmp/*.deb"