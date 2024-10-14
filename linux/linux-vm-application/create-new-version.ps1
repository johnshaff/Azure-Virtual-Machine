$galleryName = "linuxAppGallery"
$rgName = "linuxRG"
$applicationName = "apache2"
$version = "1.0.0"

New-AzGalleryApplicationVersion `
    -ResourceGroupName $rgName `
    -GalleryName $galleryName `
    -GalleryApplicationName $applicationName `
    -Name $version `
    -PackageFileLink "https://<storage account name>.blob.core.windows.net/<container name>/<filename>" `
    -DefaultConfigFileLink "https://<storage account name>.blob.core.windows.net/<container name>/<filename>" `
    -Location "East US" `
    -Install "mv myApp .\myApp\myApp" `
    -Remove "rm .\myApp\myApp" 