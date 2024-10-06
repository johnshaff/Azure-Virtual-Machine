
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

#--------------------------------------------
# VIRTUAL MACHINE & NETWORKING
#--------------------------------------------

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

#--------------------------------------------
# APPLICATION INSTALLATION
#--------------------------------------------

# Define the commands to be executed on the VMs to install the web server
$scriptBlock = {
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value "Hello World from host $($env:computername)!"
    "Web Server installed and Default.htm created on $($env:computername)"
}

# Invoke the installation script on the VM
$installResult = Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $vmName -CommandId 'RunPowerShellScript' -ScriptString $scriptBlock

# Display the output for the installation script
$installResult.Value[0].Message


Write-Host "Open Windows Remote Desktop app and add the following public IP address to connect to your VM:"
Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object IpAddress
