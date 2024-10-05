
# List all available publishers for a specific location
# $locName = "eastus"
# Get-AzVMImagePublisher -Location $locName | Select-Object PublisherName

# # List all available offers for a specific publisher
# $pubName = "Debian"
# Get-AzVMImageOffer -Location $locName -PublisherName $pubName | Select-Object Offer

# # List all available skus for a specific offer
# $offerName = "debian-11"
# Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select-Object Skus

# # List all available versions for a specific sku
# $skuName = "11"
# Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select-Object Skus, Version


#az vm image list --location eastus --publisher debian --all --output table

# az vm image list `
# --location eastus `
# --publisher debian `
# --all `
# --query "[:10].{Publisher:publisher, Offer:offer, Architecture:architecture, Sku:sku, Version:version, URN:urn}" `
# --output table