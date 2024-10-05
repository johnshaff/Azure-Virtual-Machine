
#create a resource group
$resourceGroupName = "windowsRG"
$location = "EastUS"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# User credentials
$securePassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("adminuser", $securePassword)

# VM naming
$vmName = "Win19VM"
$vnetName = "Win19VNET"
$subnetName = "web"
$nsgName = "Win19_NetworkSecurityGroup"
$publicIpName = "Win19_PublicIpAddress"

# Create a new VM
New-AzVm `
    -ResourceGroupName $resourceGroupName `
    -Name $vmName `
    -Location $location `
    -Image "Win2019Datacenter" `
    -Size "Standard_D2s_v3" `
    -VirtualNetworkName $vnetName `
    -AddressPrefix "10.0.0.0/16" `
    -SubnetName $subnetName `
    -SubnetAddressPrefix "10.0.0.0/24" `
    -SecurityGroupName $nsgName `
    -PublicIpAddressName $publicIpName `
    -OpenPorts 80, 3389, 22 `
    -Credential $credential `
    -Zone 1

Write-Host "Open Windows Remote Desktop app and add the following public IP address to connect to your VM:"
Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object IpAddress
