<# 

MOST COMMON LINUX PUBLISHER NAMES
1. Canonical (ie. Ubuntu)
2. OpenLogic (ie. CentOS)
3. RedHat
4. SUSE
5. Debian

You can copy and paste these publisher names below
#>

# Define the publisher name
$publisher = "canonical"

# Fetch all images for the publisher 'debian' in 'eastus' location
$images = az vm image list --location eastus --publisher $publisher --all --output json | ConvertFrom-Json

# Group images by Offer and SKU
$imagesByOfferSku = $images | Group-Object -Property offer, sku

$latestImages = @()

# For each Offer-SKU group, find the image with the latest version
foreach ($group in $imagesByOfferSku) {
    $offerSkuImages = $group.Group
    # Sort images by version (as strings, since the format allows correct string comparison)
    $sortedImages = $offerSkuImages | Sort-Object -Property version
    # Get the last image (latest version)
    $latestImage = $sortedImages[-1]
    $latestImages += $latestImage
}

# Output the list of latest images in a table format
$latestImages | Select-Object Publisher, Offer, Architecture, Sku, Version, Urn | Format-Table -AutoSize