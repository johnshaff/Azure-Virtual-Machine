
#create a resource group
New-AzResourceGroup -Name 'windowsRG' -Location 'EastUS'

# Create a secure password
$securePassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force

# Create the credential object
$credential = New-Object System.Management.Automation.PSCredential ("adminuser", $securePassword)

New-AzVm `
    -ResourceGroupName "windowsRG" `
    -Name "Win19VM" `
    -Location "EastUS" `
    -Image "Win2019Datacenter" `
    -Size "Standard_D2s_v3" `
    -VirtualNetworkName "Win19VNET" `
    -AddressPrefix "10.0.0.0/16" `
    -SubnetName "web" `
    -SubnetAddressPrefix "10.0.0.0/24" `
    -SecurityGroupName "Win19_NetworkSecurityGroup" `
    -PublicIpAddressName "Win19_PublicIpAddress" `
    -OpenPorts 80, 3389, 22 `
    -Credential $credential `
    -Zone 1

Write-Host "Open the Windows Remote Desktop app and add the following public IP address to connect to your VM."
Get-AzPublicIpAddress -ResourceGroupName "windowsRG"  | Select-Object IpAddress




